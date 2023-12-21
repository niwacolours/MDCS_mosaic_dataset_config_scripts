# SCENZ Project 2023/2024 Demo
# Script used for the automatic creation of Image Services based on Mosaic Datasets from NetCDF/LERC files
# specificially using existing raster data in the SCENZ directories 
# 
# IMPORTANT: *** (use another script for updates) ***
#
#
# This script can be used to invoke MDCS (Mosaic Dataset Configuration System) scripts in parallel
# to improve the execution speed on many processors
# The configuration below executes 4 Mosaic Dataset Creation scripts in parallel to create File Geodatabases for the parameters (File locking would otherwise prevent parallel writes)
# it works in parallel in 4 Timesteps (to run all variable parameters in sequence)
# 
# 
# Directory configured  in XML files: C:\Common\ArcGIS\PUBLISHING_APRX\SCENZ\MRF_LERC_PROD_5 (this is where rasters and GDBs are stored)

# ===============================
# Setup - an install of Esri's MDCS Mosaic Dataset Configuration Scripts is needed. Configure its install location here:
# ===============================
$MDCSpath = 'c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\mdcs.py'

$myXML = '-i:"c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\Mosaic_Dataset_Initial_Creation_PROD_V5.xml"'
$config_combineTimeseriesPROD = '-i:"c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\05_PROD_Combine_TIMESERIES_NZTM.xml"'
$config_combineAnomalyPROD = '-i:"c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\05_PROD_Combine_ANOMALY_NZTM.xml"'
$config_combineClimatologyPROD = '-i:"c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\05_PROD_Combine_CLIMATOLOGY_NZTM.xml"'
            
[String[]]$variables = ('ADET', 'BBP', 'CHL', 'EBED', 'HVIS', 'KPAR', 'PAR', 'POB', 'SEC', 'SST', 'TSS')

# ****** CHANGE WHICH OF TIME/ANOMALY/CLIMATOLOGY to WORK on HERE *****
# Remember to run the script for all three options - individually, so come back and change this again after one run has finished:

#[String[]]$timeSteps = ( 'YR', 'SE', 'MO', '7D') # for Timeseries
[String[]]$timeSteps = ( 'YC', 'SC', 'MC', '7C') # for Climatologies
#[String[]]$timeSteps = ( 'YA', 'SA', 'MA', '7A') # for Anomalies



$sp_flag_ = '-p:setpropertybymosaic$sp_flag'
$sp_mosaic_ = '-p:c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\03_PROD\ChildParent_PROD_V3_all_Children_NZTM.gdb\PROD_V3_All_ANOMALY_Children_NZTM$sp_mosaic'

$tsd = '-p:3$ti'
$tsu = '-p:Months$tiu'

$groupName_YR_ = '-p:AnnualTimeseries$groupName'
$groupName_SE_ = '-p:SeasonalTimeseries$groupName'
$groupName_MO_ = '-p:MonthlyTimeseries$groupName'
$groupName_7D_ = '-p:7DayTimeseries$groupName'


$groupName_YC_ = '-p:AnnualClimatology$groupName'
$groupName_SC_ = '-p:SeasonalClimatology$groupName'
$groupName_MC_ = '-p:MonthlyClimatology$groupName'
$groupName_7C_ = '-p:7DayClimatology$groupName'


$groupName_YA_ = '-p:AnnualAnomalies$groupName'
$groupName_SA_ = '-p:SeasonalAnomalies$groupName'
$groupName_MA_ = '-p:MonthlyAnomalies$groupName'
$groupName_7A_ = '-p:7DayAnomalies$groupName'

function Invoke-Command-Groups {
    
    foreach ($vari in $variables) {
        #$period
        # configuration used to create individual datasets
        
        $myVarName = '-p:' + "$vari" + '$VariableName'
        if (($vari.Length) -eq 3) {
            $myInputRasterPath = '-p:' + "$vari" + '_$inputRasterPath'
        }
        if (($vari.Length) -eq 4) {
            $myInputRasterPath = '-p:' + "$vari" + '$inputRasterPath'
        }
        
        #$command_list = @('')
            
            
        foreach ($period in $timeSteps) {
            $vari
            $period
            $myGDBname = '-p:SCENZ_ALL_' + $period + '$GDBname'
            # $myGDBname = '-p:NIWAGISADMIN@GISDBsAG.niwa.local$GDBname'
        
            $myMDSname = '-p:' + "SCENZ_ALL_" + $period + '$MDS_name'
            $myFilterExpression = '-p:_' + $period + '_$filterExpression'
            $myDesriptionString = '-p:' + $vari + '_' + $period + '_Description$variablDesc'    
            $myRFTname = '-p:' + $vari + '_' + $period + '$RFTname' 
            $myRFTname

            $arguments_currentvar_SE = ""
            $arguments_currentvar_YR = ""
            $arguments_currentvar_MO = ""
            $arguments_currentvar_7D = ""

            # commands for Timeseries
            if ($period -eq 'SE') {
                $arguments_currentvar_SE = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_SE_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_S = ($MDCSpath + " " + $arguments_currentvar_SE)
                $command_line_S
                
                continue
            }
        
            elseif ($period -eq 'YR') {
                $arguments_currentvar_YR = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_YR_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
              
                $command_line_Y = ($MDCSpath + " " + $arguments_currentvar_YR )
                $command_line_Y
                
                continue
            }

            elseif ($period -eq 'MO') {
                $arguments_currentvar_MO = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_MO_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_M = ($MDCSpath + " " + $arguments_currentvar_MO)
                $command_line_M
               
                continue
            }
    
            elseif ($period -eq '7D') {
                $arguments_currentvar_7D = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_7D_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_7 = ($MDCSpath + " " + $arguments_currentvar_7D )
                $command_line_7
                
                continue
            }
           
            # Commands for Climatology:
            if ($period -eq 'SC') {
                $arguments_currentvar_SC = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_SC_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_S = ($MDCSpath + " " + $arguments_currentvar_SC)
                $command_line_S
                
                continue
            }
        
            elseif ($period -eq 'YC') {
                $arguments_currentvar_YC = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_YC_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
              
                $command_line_Y = ($MDCSpath + " " + $arguments_currentvar_YC )
                $command_line_Y
                
                continue
            }

            elseif ($period -eq 'MC') {
                $arguments_currentvar_MC = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_MC_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString
                
                $command_line_M = ($MDCSpath + " " + $arguments_currentvar_MC)
                $command_line_M
               
                continue
            }
    
            elseif ($period -eq '7C') {
                $arguments_currentvar_7C = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_7C_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString
                
                $command_line_7 = ($MDCSpath + " " + $arguments_currentvar_7C )
                $command_line_7
                
                continue
            }

            # commands for Anomalies
            if ($period -eq 'SA') {
                $arguments_currentvar_SA = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_SA_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_S = ($MDCSpath + " " + $arguments_currentvar_SA)
                $command_line_S
                
                continue
            }
        
            elseif ($period -eq 'YA') {
                $arguments_currentvar_YA = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_YA_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
              
                $command_line_Y = ($MDCSpath + " " + $arguments_currentvar_YA )
                $command_line_Y
                
                continue
            }

            elseif ($period -eq 'MA') {
                $arguments_currentvar_MA = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_MA_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString 
                
                $command_line_M = ($MDCSpath + " " + $arguments_currentvar_MA)
                $command_line_M
               
                continue
            }
    
            elseif ($period -eq '7A') {
                $arguments_currentvar_7A = $myXML, $myVarName, $myGDBname, $myMDSname, $myInputRasterPath , $myFilterExpression , $groupName_7A_ , $myRFTname, $sp_mosaic_, $sp_flag_, $tsd, $tsu, $myDesriptionString
                
                $command_line_7 = ($MDCSpath + " " + $arguments_currentvar_7A )
                $command_line_7
                
                continue
            }
        }

        $ready = 'Ready to run'
        $ready
        # === RUN processing for this variable, for all timesteps and wait for it to finish before running next (only one group of timesteps can be executed in one loop)==
        
        $procs = $(Start-Process $env:PYTHONBIN $command_line_S -PassThru; Start-Process $env:PYTHONBIN $command_line_Y -PassThru; Start-Process $env:PYTHONBIN $command_line_M -PassThru; Start-Process $env:PYTHONBIN $command_line_7 -PassThru)
       
        $procs | Wait-Process
        $finished = 'Finished run' + $vari + "_" + $period + "\n\n"
        $finished
    }
   

}


function Invoke-Finalize_MDCS {

    foreach ($period in $timeSteps) {
        $period
        
        
        $commandSetFinalize = '-c:BB+CC+AI+BMI'
        #$commandSetFinalize = '-c:CRA+CSDD'
        #$commandSetFinalize = '-c:BMI+CSDD' # can run a few commands separately, if needed
        # When publishing image services is required also run CSDD+STD+USD:
        # $commandSetFinalize = '-c:BB+CC+AI+BMI+CSDD+STS+USD'
    
        $myGDBname = '-p:SCENZ_ALL_' + $period + '$GDBname'
        $myMDSname = '-p:' + "SCENZ_ALL_" + $period + '$MDS_name'
        $arguments_FINALIZE = $commandSetFinalize, $myXML, $myGDBname, $myMDSname
        $command_line_FINALIZE = ($MDCSpath + " " + $arguments_FINALIZE)
        $command_line_FINALIZE
        
        $finalizing = 'Finalizing run' + $period
        $finalizing
        Start-Process $env:PYTHONBIN $command_line_FINALIZE | Wait-Process
    }
}

function Invoke-Combine_MosaicDatasets {
    if ($timeSteps -contains 'YR') {
        $combiningT = 'Running MDCS to combine Timeseries'
        $combiningT
        $combineTimeseries_Command = ($MDCSpath + " " + $config_combineTimeseriesPROD)
        Start-Process $env:PYTHONBIN $combineTimeseries_Command  | Wait-Process
        $finished = 'Finished running' + $combineTimeseries_Command + '\n'
        $finished
    }
    elseif ($timeSteps -contains 'YA') {
        $combiningA = 'Running MDCS to combine Anomalies'
        $combiningA
        $combineAnomaly_Command = ($MDCSpath + " " + $config_combineAnomalyPROD) 
        Start-Process $env:PYTHONBIN $combineAnomaly_Command | Wait-Process
        $finished = 'Finished running' + $combineAnomaly_Command + '\n'
        $finished
    }
    elseif ($timeSteps -contains 'YC') {
        #elseif ($timeSteps -contains 'MC') {
        $combiningC = 'Running MDCS to combine Climatology'
        $combiningC
        $combineClimate_Command = ($MDCSpath + " " + $config_combineClimatologyPROD)
        Start-Process $env:PYTHONBIN $combineClimate_Command | Wait-Process
        $finished = 'Finished running' + $combineClimate_Command + '\n'
        $finished
    }

}

## ===== STEP1: CREATE all Mosaic Datasets for all variables in the timesteps:
Invoke-Command-Groups ($variables)

## ===== STEP2: FINALIZE the Mosaic Datasets (add indexes, boundary, cell size, raster function templates etc.) and create service definition for publishing as Image Services
Invoke-Finalize_MDCS($timeSteps)


## # ====== STEP3: HERE we would normally run the script "Create_V5_ALL_TRANSPOSED_CRF.py"
## # THIS HAS PREVIOUSLY BEEN RUN in the TEST environment - with data copied to PROD So WE WON'T RUN IT HERE

## Start-Process $env:PYTHONBIN  r"c:\Image_Mgmt_Workflows\mdcs-py-master\Scripts\Create_V5_ALL_TRANSPOSED_CRF.py"


# ====== STEP4: RUN SCRIPT TO COMBINE the Mosaic Datasets from Step 1 and Step 2 into the output Mosaic Datasets for the T,A,C Image Services
Invoke-Combine_MosaicDatasets($timeSteps)

