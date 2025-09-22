library(dplyr)

full.data <-
  read.table(file = '/Users/Schle008/Dropbox/Research/my_projects/Primate_Eyetracking_Network/Study_1/PET_network_study1_Ngamba_Data_Export_incl_AOIs.tsv', sep = '\t', header = TRUE)
str(full.data)

cols_with_AOI <- full.data %>%
  select(starts_with("AOI")) %>%
  names()
print(cols_with_AOI)

# delete all NAs
full.data  <- full.data  %>%
select(where(~ !all(is.na(.))))

full.data  <- full.data  %>%
  rename(
    #Gravity Ver 1

    'AOI.hit.gravity.ver1.cont.apple'  = 'AOI.hit..gravity_ver1_n_cont...Ellipse.',
    'AOI.hit.gravity.ver1.test.apple' = 'AOI.hit..gravity_ver1_n_test...Ellipse.',

    'AOI.hit.gravity.ver1.cont.whole.screen'  = 'AOI.hit..gravity_ver1_n_cont...Gravity_Ver1_WholeScreen.',
    'AOI.hit.gravity.ver1.test.whole.screen' = 'AOI.hit..gravity_ver1_n_test...Gravity_Ver1_WholeScreen.',

    'AOI.hit.gravity.ver1.cont.supr.event'  = 'AOI.hit..gravity_ver1_n_cont...Polygon.',
    'AOI.hit.gravity.ver1.test.supr.event' = 'AOI.hit..gravity_ver1_n_test...Polygon.',

    #Gravity Ver 2

    'AOI.hit.gravity.ver2.cont.apple' = 'AOI.hit..gravity_ver2_n_cont...Ellipse.',
    'AOI.hit.gravity.ver2.test.apple' = 'AOI.hit..gravity_ver2_n_test...Ellipse.',

    'AOI.hit.gravity.ver2.cont.whole.screen' = 'AOI.hit..gravity_ver2_n_cont...Gravity_Ver2_WholeScreen.',
    'AOI.hit.gravity.ver2.test.whole.screen' = 'AOI.hit..gravity_ver2_n_test...Gravity_Ver2_WholeScreen.',

    'AOI.hit.gravity.ver2.cont.supr.event' = 'AOI.hit..gravity_ver2_n_cont...Polygon.',
    'AOI.hit.gravity.ver2.test.supr.event' = 'AOI.hit..gravity_ver2_n_test...Polygon.',

    #Solidity Ver 1

    'AOI.hit.solidity.ver1.cont.apple'  = 'AOI.hit..solidity_ver1_n_cont...Ellipse.',
    'AOI.hit.solidity.ver1.test.apple'  = 'AOI.hit..solidity_ver1_n_test...Ellipse.',

    'AOI.hit.solidity.ver1.cont.supr.event'  = 'AOI.hit..solidity_ver1_n_cont...Polygon.',
    'AOI.hit.solidity.ver1.test.supr.event'  = 'AOI.hit..solidity_ver1_n_test...Polygon.1.',

    'AOI.hit.solidity.ver1.cont.whole.screen'  = 'AOI.hit..solidity_ver1_n_cont...Solidity_Ver1_WholeScreen.',
    'AOI.hit.solidity.ver1.test.whole.screen'  = 'AOI.hit..solidity_ver1_n_test...Solidity_Ver1_WholeScreen.',

    #Solidity Ver 2

    'AOI.hit.solidity.ver2.cont.apple' = 'AOI.hit..solidity_ver2_n_cont...Ellipse.',
    'AOI.hit.solidity.ver2.test.apple' = 'AOI.hit..solidity_ver2_n_test...Ellipse.',

    # here I two rectangles, but for each video, but there should only ne one. I need to check which one is correct.
    # For now I chose the AOIs that have more hits (since we made it larger)
    # Please be aware in the analysis that this might still change when I can check the Tobii project

    'AOI.hit.solidity.ver2.cont.supr.event' = 'AOI.hit..solidity_ver2_n_cont...Rectangle.',
    'AOI.hit.solidity.ver2.test.supr.event' = 'AOI.hit..solidity_ver2_n_test...Rectangle.1.',

    # 'AOI.hit.solidity.ver2.cont.supr.event' = 'AOI.hit..solidity_ver2_n_cont...Rectangle.2.',
    # 'AOI.hit.solidity.ver2.test.supr.event' = 'AOI.hit..solidity_ver2_n_test...Rectangle.2.',

    'AOI.hit.solidity.ver2.cont.whole.screen' = 'AOI.hit..solidity_ver2_n_cont...Solidity_Ver2_WholeScreen.',
    'AOI.hit.solidity.ver2.test.whole.screen' = 'AOI.hit..solidity_ver2_n_test...Solidity_Ver2_WholeScreen.',

    #Continuity Ver 1

    'AOI.hit.continuity.ver1.cont.apple' = 'AOI.hit..continuity_ver1_n_cont...Ellipse.',
    'AOI.hit.continuity.ver1.test.apple' = 'AOI.hit..continuity_ver1_n_test...Ellipse.',

    # here I two rectangles, but for each video, but there should only ne one. I need to check which one is correct.
    # For now I chose the AOIs that have more hits (since we made it larger)
    # Please be aware in the analysis that this might still change when I can check the Tobii project

    'AOI.hit.continuity.ver1.cont.supr.event' = 'AOI.hit..continuity_ver1_n_cont...Rectangle.1.',
    'AOI.hit.continuity.ver1.test.supr.event' = 'AOI.hit..continuity_ver1_n_test...Rectangle.1.',

    # 'AOI.hit.continuity.ver1.cont.supr.event' = 'AOI.hit..continuity_ver1_n_cont...Rectangle.2.',
    # 'AOI.hit.continuity.ver1.test.supr.event' = 'AOI.hit..continuity_ver1_n_test...Rectangle.',

    'AOI.hit.continuity.ver1.cont.whole.screen'  = 'AOI.hit..continuity_ver1_n_cont...Cont_Ver1_WholeScreen.',
    'AOI.hit.continuity.ver1.test.whole.screen' = 'AOI.hit..continuity_ver1_n_test...Cont_Ver1_WholeScreen.',

    #Continuity Ver 2

    'AOI.hit.continuity.ver2.cont.apple' = 'AOI.hit..continuity_ver2_n_cont...Ellipse.',
    'AOI.hit.continuity.ver2.test.apple' = 'AOI.hit..continuity_ver2_n_test...Ellipse.',

    'AOI.hit.continuity.ver2.cont.supr.event' = 'AOI.hit..continuity_ver2_n_cont...Rectangle.1.',
    'AOI.hit.continuity.ver2.test.supr.event' = 'AOI.hit..continuity_ver2_n_test...Rectangle.1.',

    'AOI.hit.continuity.ver2.cont.whole.screen' = 'AOI.hit..continuity_ver2_n_cont...Cont_Ver2_WholeScreen.',
    'AOI.hit.continuity.ver2.test.whole.screen' = 'AOI.hit..continuity_ver2_n_test...Cont_Ver2_WholeScreen.',

  )
