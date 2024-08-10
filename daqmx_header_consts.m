classdef daqmx_header_consts
    properties (Constant)
        DAQmx_AIConv_ActiveEdge = hex2dec('1853');
        DAQmx_AIConv_DigFltr_Enable = hex2dec('2EDC');
        DAQmx_AIConv_DigFltr_MinPulseWidth = hex2dec('2EDD');
        DAQmx_AIConv_DigFltr_TimebaseRate = hex2dec('2EDF');
        DAQmx_AIConv_DigFltr_TimebaseSrc = hex2dec('2EDE');
        DAQmx_AIConv_DigSync_Enable = hex2dec('2EE0');
        DAQmx_AIConv_MaxRate = hex2dec('22C9');
        DAQmx_AIConv_Rate = hex2dec('1848');
        DAQmx_AIConv_Src = hex2dec('1502');
        DAQmx_AIConv_TimebaseDiv = hex2dec('1335');
        DAQmx_AIConv_Timebase_Src = hex2dec('1339');
        DAQmx_AI_ACExcit_Freq = hex2dec('0101');
        DAQmx_AI_ACExcit_SyncEnable = hex2dec('0102');
        DAQmx_AI_ACExcit_WireMode = hex2dec('18CD');
        DAQmx_AI_ADCCustomTimingMode = hex2dec('2F6B');
        DAQmx_AI_ADCTimingMode = hex2dec('29F9');
        DAQmx_AI_Accel_4WireDCVoltage_Sensitivity = hex2dec('3115');
        DAQmx_AI_Accel_4WireDCVoltage_SensitivityUnits = hex2dec('3116');
        DAQmx_AI_Accel_Charge_Sensitivity = hex2dec('3113');
        DAQmx_AI_Accel_Charge_SensitivityUnits = hex2dec('3114');
        DAQmx_AI_Accel_Sensitivity = hex2dec('0692');
        DAQmx_AI_Accel_SensitivityUnits = hex2dec('219C');
        DAQmx_AI_Accel_Units = hex2dec('0673');
        DAQmx_AI_Accel_dBRef = hex2dec('29B2');
        DAQmx_AI_Atten = hex2dec('1801');
        DAQmx_AI_AutoZeroMode = hex2dec('1760');
        DAQmx_AI_AveragingWinSize = hex2dec('2FEE');
        DAQmx_AI_Bridge_Balance_CoarsePot = hex2dec('17F1');
        DAQmx_AI_Bridge_Balance_FinePot = hex2dec('18F4');
        DAQmx_AI_Bridge_Cfg = hex2dec('0087');
        DAQmx_AI_Bridge_ElectricalUnits = hex2dec('2F87');
        DAQmx_AI_Bridge_InitialRatio = hex2dec('2F86');
        DAQmx_AI_Bridge_InitialVoltage = hex2dec('17ED');
        DAQmx_AI_Bridge_NomResistance = hex2dec('17EC');
        DAQmx_AI_Bridge_PhysicalUnits = hex2dec('2F88');
        DAQmx_AI_Bridge_Poly_ForwardCoeff = hex2dec('2F90');
        DAQmx_AI_Bridge_Poly_ReverseCoeff = hex2dec('2F91');
        DAQmx_AI_Bridge_ScaleType = hex2dec('2F89');
        DAQmx_AI_Bridge_ShuntCal_Enable = hex2dec('0094');
        DAQmx_AI_Bridge_ShuntCal_GainAdjust = hex2dec('193F');
        DAQmx_AI_Bridge_ShuntCal_Select = hex2dec('21D5');
        DAQmx_AI_Bridge_ShuntCal_ShuntCalAActualResistance = hex2dec('2F79');
        DAQmx_AI_Bridge_ShuntCal_ShuntCalAResistance = hex2dec('2F78');
        DAQmx_AI_Bridge_ShuntCal_ShuntCalASrc = hex2dec('30CA');
        DAQmx_AI_Bridge_ShuntCal_ShuntCalBActualResistance = hex2dec('2F7B');
        DAQmx_AI_Bridge_ShuntCal_ShuntCalBResistance = hex2dec('2F7A');
        DAQmx_AI_Bridge_Table_ElectricalVals = hex2dec('2F8E');
        DAQmx_AI_Bridge_Table_PhysicalVals = hex2dec('2F8F');
        DAQmx_AI_Bridge_TwoPointLin_First_ElectricalVal = hex2dec('2F8A');
        DAQmx_AI_Bridge_TwoPointLin_First_PhysicalVal = hex2dec('2F8B');
        DAQmx_AI_Bridge_TwoPointLin_Second_ElectricalVal = hex2dec('2F8C');
        DAQmx_AI_Bridge_TwoPointLin_Second_PhysicalVal = hex2dec('2F8D');
        DAQmx_AI_Bridge_Units = hex2dec('2F92');
        DAQmx_AI_ChanCal_ApplyCalIfExp = hex2dec('2299');
        DAQmx_AI_ChanCal_Desc = hex2dec('22A4');
        DAQmx_AI_ChanCal_EnableCal = hex2dec('2298');
        DAQmx_AI_ChanCal_HasValidCalInfo = hex2dec('2297');
        DAQmx_AI_ChanCal_OperatorName = hex2dec('22A3');
        DAQmx_AI_ChanCal_Poly_ForwardCoeff = hex2dec('229F');
        DAQmx_AI_ChanCal_Poly_ReverseCoeff = hex2dec('22A0');
        DAQmx_AI_ChanCal_ScaleType = hex2dec('229C');
        DAQmx_AI_ChanCal_Table_PreScaledVals = hex2dec('229D');
        DAQmx_AI_ChanCal_Table_ScaledVals = hex2dec('229E');
        DAQmx_AI_ChanCal_Verif_AcqVals = hex2dec('22A2');
        DAQmx_AI_ChanCal_Verif_RefVals = hex2dec('22A1');
        DAQmx_AI_Charge_Units = hex2dec('3112');
        DAQmx_AI_ChopEnable = hex2dec('3143');
        DAQmx_AI_Coupling = hex2dec('0064');
        DAQmx_AI_CurrentShunt_Loc = hex2dec('17F2');
        DAQmx_AI_CurrentShunt_Resistance = hex2dec('17F3');
        DAQmx_AI_Current_ACRMS_Units = hex2dec('17E3');
        DAQmx_AI_Current_Units = hex2dec('0701');
        DAQmx_AI_CustomScaleName = hex2dec('17E0');
        DAQmx_AI_DCOffset = hex2dec('2A89');
        DAQmx_AI_DataXferCustomThreshold = hex2dec('230C');
        DAQmx_AI_DataXferMaxRate = hex2dec('3117');
        DAQmx_AI_DataXferMech = hex2dec('1821');
        DAQmx_AI_DataXferReqCond = hex2dec('188B');
        DAQmx_AI_DevScalingCoeff = hex2dec('1930');
        DAQmx_AI_DigFltr_Bandpass_CenterFreq = hex2dec('30C3');
        DAQmx_AI_DigFltr_Bandpass_Width = hex2dec('30C4');
        DAQmx_AI_DigFltr_Coeff = hex2dec('30C7');
        DAQmx_AI_DigFltr_Enable = hex2dec('30BD');
        DAQmx_AI_DigFltr_Highpass_CutoffFreq = hex2dec('30C2');
        DAQmx_AI_DigFltr_Lowpass_CutoffFreq = hex2dec('30C1');
        DAQmx_AI_DigFltr_Notch_CenterFreq = hex2dec('30C5');
        DAQmx_AI_DigFltr_Notch_Width = hex2dec('30C6');
        DAQmx_AI_DigFltr_Order = hex2dec('30C0');
        DAQmx_AI_DigFltr_Response = hex2dec('30BF');
        DAQmx_AI_DigFltr_Type = hex2dec('30BE');
        DAQmx_AI_DigFltr_Types = hex2dec('3107');
        DAQmx_AI_Dither_Enable = hex2dec('0068');
        DAQmx_AI_EddyCurrentProxProbe_Sensitivity = hex2dec('2ABE');
        DAQmx_AI_EddyCurrentProxProbe_SensitivityUnits = hex2dec('2ABF');
        DAQmx_AI_EddyCurrentProxProbe_Units = hex2dec('2AC0');
        DAQmx_AI_EnhancedAliasRejectionEnable = hex2dec('2294');
        DAQmx_AI_Excit_ActualVal = hex2dec('1883');
        DAQmx_AI_Excit_DCorAC = hex2dec('17FB');
        DAQmx_AI_Excit_IdleOutputBehavior = hex2dec('30B8');
        DAQmx_AI_Excit_Sense = hex2dec('30FD');
        DAQmx_AI_Excit_Src = hex2dec('17F4');
        DAQmx_AI_Excit_UseForScaling = hex2dec('17FC');
        DAQmx_AI_Excit_UseMultiplexed = hex2dec('2180');
        DAQmx_AI_Excit_Val = hex2dec('17F5');
        DAQmx_AI_Excit_VoltageOrCurrent = hex2dec('17F6');
        DAQmx_AI_FilterDelay = hex2dec('2FED');
        DAQmx_AI_FilterDelayAdjustment = hex2dec('3074');
        DAQmx_AI_FilterDelayUnits = hex2dec('3071');
        DAQmx_AI_Filter_Enable = hex2dec('3173');
        DAQmx_AI_Filter_Freq = hex2dec('3174');
        DAQmx_AI_Filter_Order = hex2dec('3176');
        DAQmx_AI_Filter_Response = hex2dec('3175');
        DAQmx_AI_ForceReadFromChan = hex2dec('18F8');
        DAQmx_AI_Force_IEPESensor_Sensitivity = hex2dec('2F81');
        DAQmx_AI_Force_IEPESensor_SensitivityUnits = hex2dec('2F82');
        DAQmx_AI_Force_Units = hex2dec('2F75');
        DAQmx_AI_Freq_Hyst = hex2dec('0814');
        DAQmx_AI_Freq_ThreshVoltage = hex2dec('0815');
        DAQmx_AI_Freq_Units = hex2dec('0806');
        DAQmx_AI_Gain = hex2dec('1818');
        DAQmx_AI_Impedance = hex2dec('0062');
        DAQmx_AI_InputLimitsFaultDetectEnable = hex2dec('318E');
        DAQmx_AI_InputLimitsFaultDetect_LowerLimit = hex2dec('318D');
        DAQmx_AI_InputLimitsFaultDetect_UpperLimit = hex2dec('318C');
        DAQmx_AI_InputSrc = hex2dec('2198');
        DAQmx_AI_Is_TEDS = hex2dec('2983');
        DAQmx_AI_LVDT_Sensitivity = hex2dec('0939');
        DAQmx_AI_LVDT_SensitivityUnits = hex2dec('219A');
        DAQmx_AI_LVDT_Units = hex2dec('0910');
        DAQmx_AI_LeadWireResistance = hex2dec('17EE');
        DAQmx_AI_LossyLSBRemoval_CompressedSampSize = hex2dec('22D9');
        DAQmx_AI_Lowpass_CutoffFreq = hex2dec('1803');
        DAQmx_AI_Lowpass_Enable = hex2dec('1802');
        DAQmx_AI_Lowpass_SwitchCap_ClkSrc = hex2dec('1884');
        DAQmx_AI_Lowpass_SwitchCap_ExtClkDiv = hex2dec('1886');
        DAQmx_AI_Lowpass_SwitchCap_ExtClkFreq = hex2dec('1885');
        DAQmx_AI_Lowpass_SwitchCap_OutClkDiv = hex2dec('1887');
        %********** Channel Attributes **********
        DAQmx_AI_Max = hex2dec('17DD');
        DAQmx_AI_MeasType = hex2dec('0695');
        DAQmx_AI_MemMapEnable = hex2dec('188C');
        DAQmx_AI_Microphone_Sensitivity = hex2dec('1536');
        DAQmx_AI_Min = hex2dec('17DE');
        DAQmx_AI_OpenChanDetectEnable = hex2dec('30FF');
        DAQmx_AI_OpenThrmcplDetectEnable = hex2dec('2F72');
        DAQmx_AI_OvercurrentDetectEnable = hex2dec('3194');
        DAQmx_AI_PowerSupplyFaultDetectEnable = hex2dec('3191');
        DAQmx_AI_Pressure_Units = hex2dec('2F76');
        DAQmx_AI_ProbeAtten = hex2dec('2A88');
        DAQmx_AI_RTD_A = hex2dec('1010');
        DAQmx_AI_RTD_B = hex2dec('1011');
        DAQmx_AI_RTD_C = hex2dec('1013');
        DAQmx_AI_RTD_R0 = hex2dec('1030');
        DAQmx_AI_RTD_Type = hex2dec('1032');
        DAQmx_AI_RVDT_Sensitivity = hex2dec('0903');
        DAQmx_AI_RVDT_SensitivityUnits = hex2dec('219B');
        DAQmx_AI_RVDT_Units = hex2dec('0877');
        DAQmx_AI_RawDataCompressionType = hex2dec('22D8');
        DAQmx_AI_RawSampJustification = hex2dec('0050');
        DAQmx_AI_RawSampSize = hex2dec('22DA');
        DAQmx_AI_RemoveFilterDelay = hex2dec('2FBD');
        DAQmx_AI_ResistanceCfg = hex2dec('1881');
        DAQmx_AI_Resistance_Units = hex2dec('0955');
        DAQmx_AI_Resolution = hex2dec('1765');
        DAQmx_AI_ResolutionUnits = hex2dec('1764');
        DAQmx_AI_Rng_High = hex2dec('1815');
        DAQmx_AI_Rng_Low = hex2dec('1816');
        DAQmx_AI_RosetteStrainGage_Orientation = hex2dec('2FFC');
        DAQmx_AI_RosetteStrainGage_RosetteMeasType = hex2dec('2FFD');
        DAQmx_AI_RosetteStrainGage_RosetteType = hex2dec('2FFE');
        DAQmx_AI_RosetteStrainGage_StrainChans = hex2dec('2FFB');
        DAQmx_AI_SampAndHold_Enable = hex2dec('181A');
        DAQmx_AI_SensorPower_Cfg = hex2dec('316A');
        DAQmx_AI_SensorPower_Type = hex2dec('316B');
        DAQmx_AI_SensorPower_Voltage = hex2dec('3169');
        DAQmx_AI_SoundPressure_MaxSoundPressureLvl = hex2dec('223A');
        DAQmx_AI_SoundPressure_Units = hex2dec('1528');
        DAQmx_AI_SoundPressure_dBRef = hex2dec('29B1');
        DAQmx_AI_StrainGage_Cfg = hex2dec('0982');
        DAQmx_AI_StrainGage_ForceReadFromChan = hex2dec('2FFA');
        DAQmx_AI_StrainGage_GageFactor = hex2dec('0994');
        DAQmx_AI_StrainGage_PoissonRatio = hex2dec('0998');
        DAQmx_AI_Strain_Units = hex2dec('0981');
        DAQmx_AI_TEDS_Units = hex2dec('21E0');
        DAQmx_AI_Temp_Units = hex2dec('1033');
        DAQmx_AI_TermCfg = hex2dec('1097');
        DAQmx_AI_Thrmcpl_CJCChan = hex2dec('1034');
        DAQmx_AI_Thrmcpl_CJCSrc = hex2dec('1035');
        DAQmx_AI_Thrmcpl_CJCVal = hex2dec('1036');
        DAQmx_AI_Thrmcpl_LeadOffsetVoltage = hex2dec('2FB8');
        DAQmx_AI_Thrmcpl_ScaleType = hex2dec('29D0');
        DAQmx_AI_Thrmcpl_Type = hex2dec('1050');
        DAQmx_AI_Thrmstr_A = hex2dec('18C9');
        DAQmx_AI_Thrmstr_B = hex2dec('18CB');
        DAQmx_AI_Thrmstr_C = hex2dec('18CA');
        DAQmx_AI_Thrmstr_R1 = hex2dec('1061');
        DAQmx_AI_Torque_Units = hex2dec('2F77');
        DAQmx_AI_UsbXferReqCount = hex2dec('3000');
        DAQmx_AI_UsbXferReqSize = hex2dec('2A8E');
        DAQmx_AI_Velocity_IEPESensor_Sensitivity = hex2dec('2FF6');
        DAQmx_AI_Velocity_IEPESensor_SensitivityUnits = hex2dec('2FF7');
        DAQmx_AI_Velocity_IEPESensor_dBRef = hex2dec('2FF5');
        DAQmx_AI_Velocity_Units = hex2dec('2FF4');
        DAQmx_AI_Voltage_ACRMS_Units = hex2dec('17E2');
        DAQmx_AI_Voltage_Units = hex2dec('1094');
        DAQmx_AI_Voltage_dBRef = hex2dec('29B0');
        DAQmx_AO_Common_Mode_Offset = hex2dec('31CC');
        DAQmx_AO_Current_Units = hex2dec('1109');
        DAQmx_AO_CustomScaleName = hex2dec('1188');
        DAQmx_AO_DAC_Offset_ExtSrc = hex2dec('2254');
        DAQmx_AO_DAC_Offset_Src = hex2dec('2253');
        DAQmx_AO_DAC_Offset_Val = hex2dec('2255');
        DAQmx_AO_DAC_Ref_AllowConnToGnd = hex2dec('1830');
        DAQmx_AO_DAC_Ref_ConnToGnd = hex2dec('0130');
        DAQmx_AO_DAC_Ref_ExtSrc = hex2dec('2252');
        DAQmx_AO_DAC_Ref_Src = hex2dec('0132');
        DAQmx_AO_DAC_Ref_Val = hex2dec('1832');
        DAQmx_AO_DAC_Rng_High = hex2dec('182E');
        DAQmx_AO_DAC_Rng_Low = hex2dec('182D');
        DAQmx_AO_DataXferMech = hex2dec('0134');
        DAQmx_AO_DataXferReqCond = hex2dec('183C');
        DAQmx_AO_DevScalingCoeff = hex2dec('1931');
        DAQmx_AO_EnhancedImageRejectionEnable = hex2dec('2241');
        DAQmx_AO_FilterDelay = hex2dec('3075');
        DAQmx_AO_FilterDelayAdjustment = hex2dec('3072');
        DAQmx_AO_FilterDelayUnits = hex2dec('3076');
        DAQmx_AO_FuncGen_Amplitude = hex2dec('2A1A');
        DAQmx_AO_FuncGen_FMDeviation = hex2dec('2A23');
        DAQmx_AO_FuncGen_Freq = hex2dec('2A19');
        DAQmx_AO_FuncGen_ModulationType = hex2dec('2A22');
        DAQmx_AO_FuncGen_Offset = hex2dec('2A1B');
        DAQmx_AO_FuncGen_Square_DutyCycle = hex2dec('2A1C');
        DAQmx_AO_FuncGen_StartPhase = hex2dec('31C4');
        DAQmx_AO_FuncGen_Type = hex2dec('2A18');
        DAQmx_AO_Gain = hex2dec('0118');
        DAQmx_AO_IdleOutputBehavior = hex2dec('2240');
        DAQmx_AO_LoadImpedance = hex2dec('0121');
        DAQmx_AO_Max = hex2dec('1186');
        DAQmx_AO_MemMapEnable = hex2dec('188F');
        DAQmx_AO_Min = hex2dec('1187');
        DAQmx_AO_OutputImpedance = hex2dec('1490');
        DAQmx_AO_OutputType = hex2dec('1108');
        DAQmx_AO_PowerAmp_ChannelEnable = hex2dec('3062');
        DAQmx_AO_PowerAmp_Gain = hex2dec('3065');
        DAQmx_AO_PowerAmp_Offset = hex2dec('3066');
        DAQmx_AO_PowerAmp_Overcurrent = hex2dec('3064');
        DAQmx_AO_PowerAmp_ScalingCoeff = hex2dec('3063');
        DAQmx_AO_ReglitchEnable = hex2dec('0133');
        DAQmx_AO_Resolution = hex2dec('182C');
        DAQmx_AO_ResolutionUnits = hex2dec('182B');
        DAQmx_AO_TermCfg = hex2dec('188E');
        DAQmx_AO_UsbXferReqCount = hex2dec('3001');
        DAQmx_AO_UsbXferReqSize = hex2dec('2A8F');
        DAQmx_AO_UseOnlyOnBrdMem = hex2dec('183A');
        DAQmx_AO_Voltage_CurrentLimit = hex2dec('2A1D');
        DAQmx_AO_Voltage_Units = hex2dec('1184');
        DAQmx_AdvTrig_Type = hex2dec('1365');
        DAQmx_AnlgEdge_RefTrig_Coupling = hex2dec('2235');
        DAQmx_AnlgEdge_RefTrig_DigFltr_Enable = hex2dec('2EE6');
        DAQmx_AnlgEdge_RefTrig_DigFltr_MinPulseWidth = hex2dec('2EE7');
        DAQmx_AnlgEdge_RefTrig_DigFltr_TimebaseRate = hex2dec('2EE9');
        DAQmx_AnlgEdge_RefTrig_DigFltr_TimebaseSrc = hex2dec('2EE8');
        DAQmx_AnlgEdge_RefTrig_DigSync_Enable = hex2dec('2EEA');
        DAQmx_AnlgEdge_RefTrig_Hyst = hex2dec('1421');
        DAQmx_AnlgEdge_RefTrig_Lvl = hex2dec('1422');
        DAQmx_AnlgEdge_RefTrig_Slope = hex2dec('1423');
        DAQmx_AnlgEdge_RefTrig_Src = hex2dec('1424');
        DAQmx_AnlgEdge_StartTrig_Coupling = hex2dec('2233');
        DAQmx_AnlgEdge_StartTrig_DigFltr_Enable = hex2dec('2EE1');
        DAQmx_AnlgEdge_StartTrig_DigFltr_MinPulseWidth = hex2dec('2EE2');
        DAQmx_AnlgEdge_StartTrig_DigFltr_TimebaseRate = hex2dec('2EE4');
        DAQmx_AnlgEdge_StartTrig_DigFltr_TimebaseSrc = hex2dec('2EE3');
        DAQmx_AnlgEdge_StartTrig_DigSync_Enable = hex2dec('2EE5');
        DAQmx_AnlgEdge_StartTrig_Hyst = hex2dec('1395');
        DAQmx_AnlgEdge_StartTrig_Lvl = hex2dec('1396');
        DAQmx_AnlgEdge_StartTrig_Slope = hex2dec('1397');
        DAQmx_AnlgEdge_StartTrig_Src = hex2dec('1398');
        DAQmx_AnlgLvl_PauseTrig_Coupling = hex2dec('2236');
        DAQmx_AnlgLvl_PauseTrig_DigFltr_Enable = hex2dec('2EF0');
        DAQmx_AnlgLvl_PauseTrig_DigFltr_MinPulseWidth = hex2dec('2EF1');
        DAQmx_AnlgLvl_PauseTrig_DigFltr_TimebaseRate = hex2dec('2EF3');
        DAQmx_AnlgLvl_PauseTrig_DigFltr_TimebaseSrc = hex2dec('2EF2');
        DAQmx_AnlgLvl_PauseTrig_DigSync_Enable = hex2dec('2EF4');
        DAQmx_AnlgLvl_PauseTrig_Hyst = hex2dec('1368');
        DAQmx_AnlgLvl_PauseTrig_Lvl = hex2dec('1369');
        DAQmx_AnlgLvl_PauseTrig_Src = hex2dec('1370');
        DAQmx_AnlgLvl_PauseTrig_When = hex2dec('1371');
        DAQmx_AnlgMultiEdge_RefTrig_Couplings = hex2dec('312A');
        DAQmx_AnlgMultiEdge_RefTrig_Hysts = hex2dec('3129');
        DAQmx_AnlgMultiEdge_RefTrig_Lvls = hex2dec('3128');
        DAQmx_AnlgMultiEdge_RefTrig_Slopes = hex2dec('3127');
        DAQmx_AnlgMultiEdge_RefTrig_Srcs = hex2dec('3126');
        DAQmx_AnlgMultiEdge_StartTrig_Couplings = hex2dec('3125');
        DAQmx_AnlgMultiEdge_StartTrig_Hysts = hex2dec('3124');
        DAQmx_AnlgMultiEdge_StartTrig_Lvls = hex2dec('3123');
        DAQmx_AnlgMultiEdge_StartTrig_Slopes = hex2dec('3122');
        DAQmx_AnlgMultiEdge_StartTrig_Srcs = hex2dec('3121');
        DAQmx_AnlgWin_PauseTrig_Btm = hex2dec('1375');
        DAQmx_AnlgWin_PauseTrig_Coupling = hex2dec('2237');
        DAQmx_AnlgWin_PauseTrig_DigFltr_Enable = hex2dec('2EF5');
        DAQmx_AnlgWin_PauseTrig_DigFltr_MinPulseWidth = hex2dec('2EF6');
        DAQmx_AnlgWin_PauseTrig_DigFltr_TimebaseRate = hex2dec('2EF8');
        DAQmx_AnlgWin_PauseTrig_DigFltr_TimebaseSrc = hex2dec('2EF7');
        DAQmx_AnlgWin_PauseTrig_DigSync_Enable = hex2dec('2EF9');
        DAQmx_AnlgWin_PauseTrig_Src = hex2dec('1373');
        DAQmx_AnlgWin_PauseTrig_Top = hex2dec('1376');
        DAQmx_AnlgWin_PauseTrig_When = hex2dec('1374');
        DAQmx_AnlgWin_RefTrig_Btm = hex2dec('1428');
        DAQmx_AnlgWin_RefTrig_Coupling = hex2dec('1857');
        DAQmx_AnlgWin_RefTrig_DigFltr_Enable = hex2dec('2EEB');
        DAQmx_AnlgWin_RefTrig_DigFltr_MinPulseWidth = hex2dec('2EEC');
        DAQmx_AnlgWin_RefTrig_DigFltr_TimebaseRate = hex2dec('2EEE');
        DAQmx_AnlgWin_RefTrig_DigFltr_TimebaseSrc = hex2dec('2EED');
        DAQmx_AnlgWin_RefTrig_DigSync_Enable = hex2dec('2EEF');
        DAQmx_AnlgWin_RefTrig_Src = hex2dec('1426');
        DAQmx_AnlgWin_RefTrig_Top = hex2dec('1429');
        DAQmx_AnlgWin_RefTrig_When = hex2dec('1427');
        DAQmx_AnlgWin_StartTrig_Btm = hex2dec('1402');
        DAQmx_AnlgWin_StartTrig_Coupling = hex2dec('2234');
        DAQmx_AnlgWin_StartTrig_DigFltr_Enable = hex2dec('2EFF');
        DAQmx_AnlgWin_StartTrig_DigFltr_MinPulseWidth = hex2dec('2F00');
        DAQmx_AnlgWin_StartTrig_DigFltr_TimebaseRate = hex2dec('2F02');
        DAQmx_AnlgWin_StartTrig_DigFltr_TimebaseSrc = hex2dec('2F01');
        DAQmx_AnlgWin_StartTrig_DigSync_Enable = hex2dec('2F03');
        DAQmx_AnlgWin_StartTrig_Src = hex2dec('1400');
        DAQmx_AnlgWin_StartTrig_Top = hex2dec('1403');
        DAQmx_AnlgWin_StartTrig_When = hex2dec('1401');
        DAQmx_ArmStartTrig_Timescale = hex2dec('3132');
        DAQmx_ArmStartTrig_TimestampEnable = hex2dec('3133');
        DAQmx_ArmStartTrig_TimestampTimescale = hex2dec('3135');
        DAQmx_ArmStartTrig_TimestampVal = hex2dec('3134');
        DAQmx_ArmStartTrig_TrigWhen = hex2dec('3131');
        DAQmx_ArmStartTrig_Type = hex2dec('1414');
        DAQmx_ArmStart_Term = hex2dec('2F7F');
        DAQmx_AuxPowerErrorChans = hex2dec('31E0');
        DAQmx_AuxPowerErrorChansExist = hex2dec('31DF');
        % Please visit ni.com/info and enter the Info Code NI_BTF for more information
        %********** Buffer Attributes **********
        DAQmx_Buf_Input_BufSize = hex2dec('186C');
        DAQmx_Buf_Input_OnbrdBufSize = hex2dec('230A');
        DAQmx_Buf_Output_BufSize = hex2dec('186D');
        DAQmx_Buf_Output_OnbrdBufSize = hex2dec('230B');
        DAQmx_CI_AngEncoder_InitialAngle = hex2dec('0881');
        DAQmx_CI_AngEncoder_PulsesPerRev = hex2dec('0875');
        DAQmx_CI_AngEncoder_Units = hex2dec('18A6');
        DAQmx_CI_Count = hex2dec('0148');
        DAQmx_CI_CountEdges_ActiveEdge = hex2dec('0697');
        DAQmx_CI_CountEdges_CountDir_DigFltr_Enable = hex2dec('21F1');
        DAQmx_CI_CountEdges_CountDir_DigFltr_MinPulseWidth = hex2dec('21F2');
        DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseRate = hex2dec('21F4');
        DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseSrc = hex2dec('21F3');
        DAQmx_CI_CountEdges_CountDir_DigSync_Enable = hex2dec('21F5');
        DAQmx_CI_CountEdges_CountDir_Hyst = hex2dec('31B2');
        DAQmx_CI_CountEdges_CountDir_LogicLvlBehavior = hex2dec('309E');
        DAQmx_CI_CountEdges_CountDir_TermCfg = hex2dec('309D');
        DAQmx_CI_CountEdges_CountDir_ThreshVoltage = hex2dec('31B1');
        DAQmx_CI_CountEdges_CountReset_ActiveEdge = hex2dec('2FB2');
        DAQmx_CI_CountEdges_CountReset_DigFltr_Enable = hex2dec('2FB3');
        DAQmx_CI_CountEdges_CountReset_DigFltr_MinPulseWidth = hex2dec('2FB4');
        DAQmx_CI_CountEdges_CountReset_DigFltr_TimebaseRate = hex2dec('2FB6');
        DAQmx_CI_CountEdges_CountReset_DigFltr_TimebaseSrc = hex2dec('2FB5');
        DAQmx_CI_CountEdges_CountReset_DigSync_Enable = hex2dec('2FB7');
        DAQmx_CI_CountEdges_CountReset_Enable = hex2dec('2FAF');
        DAQmx_CI_CountEdges_CountReset_Hyst = hex2dec('31B4');
        DAQmx_CI_CountEdges_CountReset_LogicLvlBehavior = hex2dec('30A0');
        DAQmx_CI_CountEdges_CountReset_ResetCount = hex2dec('2FB0');
        DAQmx_CI_CountEdges_CountReset_Term = hex2dec('2FB1');
        DAQmx_CI_CountEdges_CountReset_TermCfg = hex2dec('309F');
        DAQmx_CI_CountEdges_CountReset_ThreshVoltage = hex2dec('31B3');
        DAQmx_CI_CountEdges_DigFltr_Enable = hex2dec('21F6');
        DAQmx_CI_CountEdges_DigFltr_MinPulseWidth = hex2dec('21F7');
        DAQmx_CI_CountEdges_DigFltr_TimebaseRate = hex2dec('21F9');
        DAQmx_CI_CountEdges_DigFltr_TimebaseSrc = hex2dec('21F8');
        DAQmx_CI_CountEdges_DigSync_Enable = hex2dec('21FA');
        DAQmx_CI_CountEdges_Dir = hex2dec('0696');
        DAQmx_CI_CountEdges_DirTerm = hex2dec('21E1');
        DAQmx_CI_CountEdges_GateWhen = hex2dec('30F5');
        DAQmx_CI_CountEdges_Gate_DigFltrEnable = hex2dec('30F1');
        DAQmx_CI_CountEdges_Gate_DigFltrMinPulseWidth = hex2dec('30F2');
        DAQmx_CI_CountEdges_Gate_DigFltrTimebaseRate = hex2dec('30F4');
        DAQmx_CI_CountEdges_Gate_DigFltrTimebaseSrc = hex2dec('30F3');
        DAQmx_CI_CountEdges_Gate_Enable = hex2dec('30ED');
        DAQmx_CI_CountEdges_Gate_Hyst = hex2dec('31B6');
        DAQmx_CI_CountEdges_Gate_LogicLvlBehavior = hex2dec('30F0');
        DAQmx_CI_CountEdges_Gate_Term = hex2dec('30EE');
        DAQmx_CI_CountEdges_Gate_TermCfg = hex2dec('30EF');
        DAQmx_CI_CountEdges_Gate_ThreshVoltage = hex2dec('31B5');
        DAQmx_CI_CountEdges_Hyst = hex2dec('31B0');
        DAQmx_CI_CountEdges_InitialCnt = hex2dec('0698');
        DAQmx_CI_CountEdges_LogicLvlBehavior = hex2dec('309C');
        DAQmx_CI_CountEdges_Term = hex2dec('18C7');
        DAQmx_CI_CountEdges_TermCfg = hex2dec('309B');
        DAQmx_CI_CountEdges_ThreshVoltage = hex2dec('31AF');
        DAQmx_CI_CtrTimebaseActiveEdge = hex2dec('0142');
        DAQmx_CI_CtrTimebaseMasterTimebaseDiv = hex2dec('18B3');
        DAQmx_CI_CtrTimebaseRate = hex2dec('18B2');
        DAQmx_CI_CtrTimebaseSrc = hex2dec('0143');
        DAQmx_CI_CtrTimebase_DigFltr_Enable = hex2dec('2271');
        DAQmx_CI_CtrTimebase_DigFltr_MinPulseWidth = hex2dec('2272');
        DAQmx_CI_CtrTimebase_DigFltr_TimebaseRate = hex2dec('2274');
        DAQmx_CI_CtrTimebase_DigFltr_TimebaseSrc = hex2dec('2273');
        DAQmx_CI_CtrTimebase_DigSync_Enable = hex2dec('2275');
        DAQmx_CI_CustomScaleName = hex2dec('189E');
        DAQmx_CI_DataXferMech = hex2dec('0200');
        DAQmx_CI_DataXferReqCond = hex2dec('2EFB');
        DAQmx_CI_DupCountPrevent = hex2dec('21AC');
        DAQmx_CI_DutyCycle_DigFltr_Enable = hex2dec('308E');
        DAQmx_CI_DutyCycle_DigFltr_MinPulseWidth = hex2dec('308F');
        DAQmx_CI_DutyCycle_DigFltr_TimebaseRate = hex2dec('3091');
        DAQmx_CI_DutyCycle_DigFltr_TimebaseSrc = hex2dec('3090');
        DAQmx_CI_DutyCycle_LogicLvlBehavior = hex2dec('30A2');
        DAQmx_CI_DutyCycle_StartingEdge = hex2dec('3092');
        DAQmx_CI_DutyCycle_Term = hex2dec('308D');
        DAQmx_CI_DutyCycle_TermCfg = hex2dec('30A1');
        DAQmx_CI_Encoder_AInputLogicLvlBehavior = hex2dec('30A4');
        DAQmx_CI_Encoder_AInputTerm = hex2dec('219D');
        DAQmx_CI_Encoder_AInputTermCfg = hex2dec('30A3');
        DAQmx_CI_Encoder_AInput_DigFltr_Enable = hex2dec('21FB');
        DAQmx_CI_Encoder_AInput_DigFltr_MinPulseWidth = hex2dec('21FC');
        DAQmx_CI_Encoder_AInput_DigFltr_TimebaseRate = hex2dec('21FE');
        DAQmx_CI_Encoder_AInput_DigFltr_TimebaseSrc = hex2dec('21FD');
        DAQmx_CI_Encoder_AInput_DigSync_Enable = hex2dec('21FF');
        DAQmx_CI_Encoder_BInputLogicLvlBehavior = hex2dec('30A6');
        DAQmx_CI_Encoder_BInputTerm = hex2dec('219E');
        DAQmx_CI_Encoder_BInputTermCfg = hex2dec('30A5');
        DAQmx_CI_Encoder_BInput_DigFltr_Enable = hex2dec('2200');
        DAQmx_CI_Encoder_BInput_DigFltr_MinPulseWidth = hex2dec('2201');
        DAQmx_CI_Encoder_BInput_DigFltr_TimebaseRate = hex2dec('2203');
        DAQmx_CI_Encoder_BInput_DigFltr_TimebaseSrc = hex2dec('2202');
        DAQmx_CI_Encoder_BInput_DigSync_Enable = hex2dec('2204');
        DAQmx_CI_Encoder_DecodingType = hex2dec('21E6');
        DAQmx_CI_Encoder_ZIndexEnable = hex2dec('0890');
        DAQmx_CI_Encoder_ZIndexPhase = hex2dec('0889');
        DAQmx_CI_Encoder_ZIndexVal = hex2dec('0888');
        DAQmx_CI_Encoder_ZInputLogicLvlBehavior = hex2dec('30A8');
        DAQmx_CI_Encoder_ZInputTerm = hex2dec('219F');
        DAQmx_CI_Encoder_ZInputTermCfg = hex2dec('30A7');
        DAQmx_CI_Encoder_ZInput_DigFltr_Enable = hex2dec('2205');
        DAQmx_CI_Encoder_ZInput_DigFltr_MinPulseWidth = hex2dec('2206');
        DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseRate = hex2dec('2208');
        DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseSrc = hex2dec('2207');
        DAQmx_CI_Encoder_ZInput_DigSync_Enable = hex2dec('2209');
        DAQmx_CI_FilterDelay = hex2dec('31BB');
        DAQmx_CI_FilterDelayUnits = hex2dec('31BC');
        DAQmx_CI_Filter_Enable = hex2dec('31B7');
        DAQmx_CI_Filter_Freq = hex2dec('31B8');
        DAQmx_CI_Filter_Order = hex2dec('31BA');
        DAQmx_CI_Filter_Response = hex2dec('31B9');
        DAQmx_CI_Freq_DigFltr_Enable = hex2dec('21E7');
        DAQmx_CI_Freq_DigFltr_MinPulseWidth = hex2dec('21E8');
        DAQmx_CI_Freq_DigFltr_TimebaseRate = hex2dec('21EA');
        DAQmx_CI_Freq_DigFltr_TimebaseSrc = hex2dec('21E9');
        DAQmx_CI_Freq_DigSync_Enable = hex2dec('21EB');
        DAQmx_CI_Freq_Div = hex2dec('0147');
        DAQmx_CI_Freq_EnableAveraging = hex2dec('2ED0');
        DAQmx_CI_Freq_Hyst = hex2dec('31AC');
        DAQmx_CI_Freq_LogicLvlBehavior = hex2dec('3098');
        DAQmx_CI_Freq_MeasMeth = hex2dec('0144');
        DAQmx_CI_Freq_MeasTime = hex2dec('0145');
        DAQmx_CI_Freq_StartingEdge = hex2dec('0799');
        DAQmx_CI_Freq_Term = hex2dec('18A2');
        DAQmx_CI_Freq_TermCfg = hex2dec('3097');
        DAQmx_CI_Freq_ThreshVoltage = hex2dec('31AB');
        DAQmx_CI_Freq_Units = hex2dec('18A1');
        DAQmx_CI_GPS_SyncMethod = hex2dec('1092');
        DAQmx_CI_GPS_SyncSrc = hex2dec('1093');
        DAQmx_CI_LinEncoder_DistPerPulse = hex2dec('0911');
        DAQmx_CI_LinEncoder_InitialPos = hex2dec('0915');
        DAQmx_CI_LinEncoder_Units = hex2dec('18A9');
        DAQmx_CI_Max = hex2dec('189C');
        DAQmx_CI_MaxMeasPeriod = hex2dec('3095');
        DAQmx_CI_MeasType = hex2dec('18A0');
        DAQmx_CI_MemMapEnable = hex2dec('2ED2');
        DAQmx_CI_Min = hex2dec('189D');
        DAQmx_CI_NumPossiblyInvalidSamps = hex2dec('193C');
        DAQmx_CI_OutputState = hex2dec('0149');
        DAQmx_CI_Period_DigFltr_Enable = hex2dec('21EC');
        DAQmx_CI_Period_DigFltr_MinPulseWidth = hex2dec('21ED');
        DAQmx_CI_Period_DigFltr_TimebaseRate = hex2dec('21EF');
        DAQmx_CI_Period_DigFltr_TimebaseSrc = hex2dec('21EE');
        DAQmx_CI_Period_DigSync_Enable = hex2dec('21F0');
        DAQmx_CI_Period_Div = hex2dec('192E');
        DAQmx_CI_Period_EnableAveraging = hex2dec('2ED1');
        DAQmx_CI_Period_Hyst = hex2dec('31AE');
        DAQmx_CI_Period_LogicLvlBehavior = hex2dec('309A');
        DAQmx_CI_Period_MeasMeth = hex2dec('192C');
        DAQmx_CI_Period_MeasTime = hex2dec('192D');
        DAQmx_CI_Period_StartingEdge = hex2dec('0852');
        DAQmx_CI_Period_Term = hex2dec('18A4');
        DAQmx_CI_Period_TermCfg = hex2dec('3099');
        DAQmx_CI_Period_ThreshVoltage = hex2dec('31AD');
        DAQmx_CI_Period_Units = hex2dec('18A3');
        DAQmx_CI_Prescaler = hex2dec('2239');
        DAQmx_CI_PulseWidth_DigFltr_Enable = hex2dec('220A');
        DAQmx_CI_PulseWidth_DigFltr_MinPulseWidth = hex2dec('220B');
        DAQmx_CI_PulseWidth_DigFltr_TimebaseRate = hex2dec('220D');
        DAQmx_CI_PulseWidth_DigFltr_TimebaseSrc = hex2dec('220C');
        DAQmx_CI_PulseWidth_DigSync_Enable = hex2dec('220E');
        DAQmx_CI_PulseWidth_LogicLvlBehavior = hex2dec('30AA');
        DAQmx_CI_PulseWidth_StartingEdge = hex2dec('0825');
        DAQmx_CI_PulseWidth_Term = hex2dec('18AA');
        DAQmx_CI_PulseWidth_TermCfg = hex2dec('30A9');
        DAQmx_CI_PulseWidth_Units = hex2dec('0823');
        DAQmx_CI_Pulse_Freq_DigFltr_Enable = hex2dec('2F06');
        DAQmx_CI_Pulse_Freq_DigFltr_MinPulseWidth = hex2dec('2F07');
        DAQmx_CI_Pulse_Freq_DigFltr_TimebaseRate = hex2dec('2F09');
        DAQmx_CI_Pulse_Freq_DigFltr_TimebaseSrc = hex2dec('2F08');
        DAQmx_CI_Pulse_Freq_DigSync_Enable = hex2dec('2F0A');
        DAQmx_CI_Pulse_Freq_LogicLvlBehavior = hex2dec('30B2');
        DAQmx_CI_Pulse_Freq_Start_Edge = hex2dec('2F05');
        DAQmx_CI_Pulse_Freq_Term = hex2dec('2F04');
        DAQmx_CI_Pulse_Freq_TermCfg = hex2dec('30B1');
        DAQmx_CI_Pulse_Freq_Units = hex2dec('2F0B');
        DAQmx_CI_Pulse_Ticks_DigFltr_Enable = hex2dec('2F16');
        DAQmx_CI_Pulse_Ticks_DigFltr_MinPulseWidth = hex2dec('2F17');
        DAQmx_CI_Pulse_Ticks_DigFltr_TimebaseRate = hex2dec('2F19');
        DAQmx_CI_Pulse_Ticks_DigFltr_TimebaseSrc = hex2dec('2F18');
        DAQmx_CI_Pulse_Ticks_DigSync_Enable = hex2dec('2F1A');
        DAQmx_CI_Pulse_Ticks_LogicLvlBehavior = hex2dec('30B6');
        DAQmx_CI_Pulse_Ticks_StartEdge = hex2dec('2F15');
        DAQmx_CI_Pulse_Ticks_Term = hex2dec('2F14');
        DAQmx_CI_Pulse_Ticks_TermCfg = hex2dec('30B5');
        DAQmx_CI_Pulse_Time_DigFltr_Enable = hex2dec('2F0E');
        DAQmx_CI_Pulse_Time_DigFltr_MinPulseWidth = hex2dec('2F0F');
        DAQmx_CI_Pulse_Time_DigFltr_TimebaseRate = hex2dec('2F11');
        DAQmx_CI_Pulse_Time_DigFltr_TimebaseSrc = hex2dec('2F10');
        DAQmx_CI_Pulse_Time_DigSync_Enable = hex2dec('2F12');
        DAQmx_CI_Pulse_Time_LogicLvlBehavior = hex2dec('30B4');
        DAQmx_CI_Pulse_Time_StartEdge = hex2dec('2F0D');
        DAQmx_CI_Pulse_Time_Term = hex2dec('2F0C');
        DAQmx_CI_Pulse_Time_TermCfg = hex2dec('30B3');
        DAQmx_CI_Pulse_Time_Units = hex2dec('2F13');
        DAQmx_CI_SampClkOverrunBehavior = hex2dec('3093');
        DAQmx_CI_SampClkOverrunSentinelVal = hex2dec('3094');
        DAQmx_CI_SemiPeriod_DigFltr_Enable = hex2dec('2219');
        DAQmx_CI_SemiPeriod_DigFltr_MinPulseWidth = hex2dec('221A');
        DAQmx_CI_SemiPeriod_DigFltr_TimebaseRate = hex2dec('221C');
        DAQmx_CI_SemiPeriod_DigFltr_TimebaseSrc = hex2dec('221B');
        DAQmx_CI_SemiPeriod_DigSync_Enable = hex2dec('221D');
        DAQmx_CI_SemiPeriod_LogicLvlBehavior = hex2dec('30B0');
        DAQmx_CI_SemiPeriod_StartingEdge = hex2dec('22FE');
        DAQmx_CI_SemiPeriod_Term = hex2dec('18B0');
        DAQmx_CI_SemiPeriod_TermCfg = hex2dec('30AF');
        DAQmx_CI_SemiPeriod_Units = hex2dec('18AF');
        DAQmx_CI_TCReached = hex2dec('0150');
        DAQmx_CI_ThreshVoltage = hex2dec('30B7');
        DAQmx_CI_Timestamp_InitialSeconds = hex2dec('22B4');
        DAQmx_CI_Timestamp_Units = hex2dec('22B3');
        DAQmx_CI_TwoEdgeSep_FirstEdge = hex2dec('0833');
        DAQmx_CI_TwoEdgeSep_FirstLogicLvlBehavior = hex2dec('30AC');
        DAQmx_CI_TwoEdgeSep_FirstTerm = hex2dec('18AD');
        DAQmx_CI_TwoEdgeSep_FirstTermCfg = hex2dec('30AB');
        DAQmx_CI_TwoEdgeSep_First_DigFltr_Enable = hex2dec('220F');
        DAQmx_CI_TwoEdgeSep_First_DigFltr_MinPulseWidth = hex2dec('2210');
        DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseRate = hex2dec('2212');
        DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseSrc = hex2dec('2211');
        DAQmx_CI_TwoEdgeSep_First_DigSync_Enable = hex2dec('2213');
        DAQmx_CI_TwoEdgeSep_SecondEdge = hex2dec('0834');
        DAQmx_CI_TwoEdgeSep_SecondLogicLvlBehavior = hex2dec('30AE');
        DAQmx_CI_TwoEdgeSep_SecondTerm = hex2dec('18AE');
        DAQmx_CI_TwoEdgeSep_SecondTermCfg = hex2dec('30AD');
        DAQmx_CI_TwoEdgeSep_Second_DigFltr_Enable = hex2dec('2214');
        DAQmx_CI_TwoEdgeSep_Second_DigFltr_MinPulseWidth = hex2dec('2215');
        DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseRate = hex2dec('2217');
        DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseSrc = hex2dec('2216');
        DAQmx_CI_TwoEdgeSep_Second_DigSync_Enable = hex2dec('2218');
        DAQmx_CI_TwoEdgeSep_Units = hex2dec('18AC');
        DAQmx_CI_UsbXferReqCount = hex2dec('3004');
        DAQmx_CI_UsbXferReqSize = hex2dec('2A92');
        DAQmx_CI_Velocity_AngEncoder_PulsesPerRev = hex2dec('30D9');
        DAQmx_CI_Velocity_AngEncoder_Units = hex2dec('30D8');
        DAQmx_CI_Velocity_Div = hex2dec('30EC');
        DAQmx_CI_Velocity_Encoder_AInputDigFltr_Enable = hex2dec('30E0');
        DAQmx_CI_Velocity_Encoder_AInputDigFltr_MinPulseWidth = hex2dec('30E1');
        DAQmx_CI_Velocity_Encoder_AInputDigFltr_TimebaseRate = hex2dec('30E3');
        DAQmx_CI_Velocity_Encoder_AInputDigFltr_TimebaseSrc = hex2dec('30E2');
        DAQmx_CI_Velocity_Encoder_AInputLogicLvlBehavior = hex2dec('30DF');
        DAQmx_CI_Velocity_Encoder_AInputTerm = hex2dec('30DD');
        DAQmx_CI_Velocity_Encoder_AInputTermCfg = hex2dec('30DE');
        DAQmx_CI_Velocity_Encoder_BInputDigFltr_Enable = hex2dec('30E7');
        DAQmx_CI_Velocity_Encoder_BInputDigFltr_MinPulseWidth = hex2dec('30E8');
        DAQmx_CI_Velocity_Encoder_BInputDigFltr_TimebaseRate = hex2dec('30EA');
        DAQmx_CI_Velocity_Encoder_BInputDigFltr_TimebaseSrc = hex2dec('30E9');
        DAQmx_CI_Velocity_Encoder_BInputLogicLvlBehavior = hex2dec('30E6');
        DAQmx_CI_Velocity_Encoder_BInputTerm = hex2dec('30E4');
        DAQmx_CI_Velocity_Encoder_BInputTermCfg = hex2dec('30E5');
        DAQmx_CI_Velocity_Encoder_DecodingType = hex2dec('30DC');
        DAQmx_CI_Velocity_LinEncoder_DistPerPulse = hex2dec('30DB');
        DAQmx_CI_Velocity_LinEncoder_Units = hex2dec('30DA');
        DAQmx_CI_Velocity_MeasTime = hex2dec('30EB');
        DAQmx_CO_AutoIncrCnt = hex2dec('0295');
        DAQmx_CO_ConstrainedGenMode = hex2dec('29F2');
        DAQmx_CO_Count = hex2dec('0293');
        DAQmx_CO_CtrTimebaseActiveEdge = hex2dec('0341');
        DAQmx_CO_CtrTimebaseMasterTimebaseDiv = hex2dec('18C3');
        DAQmx_CO_CtrTimebaseRate = hex2dec('18C2');
        DAQmx_CO_CtrTimebaseSrc = hex2dec('0339');
        DAQmx_CO_CtrTimebase_DigFltr_Enable = hex2dec('2276');
        DAQmx_CO_CtrTimebase_DigFltr_MinPulseWidth = hex2dec('2277');
        DAQmx_CO_CtrTimebase_DigFltr_TimebaseRate = hex2dec('2279');
        DAQmx_CO_CtrTimebase_DigFltr_TimebaseSrc = hex2dec('2278');
        DAQmx_CO_CtrTimebase_DigSync_Enable = hex2dec('227A');
        DAQmx_CO_DataXferMech = hex2dec('2ECC');
        DAQmx_CO_DataXferReqCond = hex2dec('2ECD');
        DAQmx_CO_EnableInitialDelayOnRetrigger = hex2dec('2EC9');
        DAQmx_CO_MemMapEnable = hex2dec('2ED3');
        DAQmx_CO_OutputState = hex2dec('0294');
        DAQmx_CO_OutputType = hex2dec('18B5');
        DAQmx_CO_Prescaler = hex2dec('226D');
        DAQmx_CO_PulseDone = hex2dec('190E');
        DAQmx_CO_Pulse_DutyCyc = hex2dec('1176');
        DAQmx_CO_Pulse_Freq = hex2dec('1178');
        DAQmx_CO_Pulse_Freq_InitialDelay = hex2dec('0299');
        DAQmx_CO_Pulse_Freq_Units = hex2dec('18D5');
        DAQmx_CO_Pulse_HighTicks = hex2dec('1169');
        DAQmx_CO_Pulse_HighTime = hex2dec('18BA');
        DAQmx_CO_Pulse_IdleState = hex2dec('1170');
        DAQmx_CO_Pulse_LowTicks = hex2dec('1171');
        DAQmx_CO_Pulse_LowTime = hex2dec('18BB');
        DAQmx_CO_Pulse_Term = hex2dec('18E1');
        DAQmx_CO_Pulse_Ticks_InitialDelay = hex2dec('0298');
        DAQmx_CO_Pulse_Time_InitialDelay = hex2dec('18BC');
        DAQmx_CO_Pulse_Time_Units = hex2dec('18D6');
        DAQmx_CO_RdyForNewVal = hex2dec('22FF');
        DAQmx_CO_UsbXferReqCount = hex2dec('3005');
        DAQmx_CO_UsbXferReqSize = hex2dec('2A93');
        DAQmx_CO_UseOnlyOnBrdMem = hex2dec('2ECB');
        DAQmx_Cal_AccConnectionCount = hex2dec('2FEB');
        DAQmx_Cal_DevTemp = hex2dec('223B');
        DAQmx_Cal_RecommendedAccConnectionCountLimit = hex2dec('2FEC');
        DAQmx_Cal_UserDefinedInfo = hex2dec('1861');
        DAQmx_Cal_UserDefinedInfo_MaxSize = hex2dec('191C');
        DAQmx_Carrier_SerialNum = hex2dec('2A8A');
        DAQmx_ChanDescr = hex2dec('1926');
        DAQmx_ChanIsGlobal = hex2dec('2304');
        DAQmx_ChanType = hex2dec('187F');
        DAQmx_Chan_SyncUnlockBehavior = hex2dec('313C');
        DAQmx_ChangeDetect_DI_FallingEdgePhysicalChans = hex2dec('2196');
        DAQmx_ChangeDetect_DI_RisingEdgePhysicalChans = hex2dec('2195');
        DAQmx_ChangeDetect_DI_Tristate = hex2dec('2EFA');
        DAQmx_DI_AcquireOn = hex2dec('2966');
        DAQmx_DI_DataXferMech = hex2dec('2263');
        DAQmx_DI_DataXferReqCond = hex2dec('2264');
        DAQmx_DI_DigFltr_Enable = hex2dec('21D6');
        DAQmx_DI_DigFltr_EnableBusMode = hex2dec('2EFE');
        DAQmx_DI_DigFltr_MinPulseWidth = hex2dec('21D7');
        DAQmx_DI_DigFltr_TimebaseRate = hex2dec('2ED5');
        DAQmx_DI_DigFltr_TimebaseSrc = hex2dec('2ED4');
        DAQmx_DI_DigSync_Enable = hex2dec('2ED6');
        DAQmx_DI_InvertLines = hex2dec('0793');
        DAQmx_DI_LogicFamily = hex2dec('296D');
        DAQmx_DI_MemMapEnable = hex2dec('296A');
        DAQmx_DI_NumLines = hex2dec('2178');
        DAQmx_DI_Tristate = hex2dec('1890');
        DAQmx_DI_UsbXferReqCount = hex2dec('3002');
        DAQmx_DI_UsbXferReqSize = hex2dec('2A90');
        DAQmx_DO_DataXferMech = hex2dec('2266');
        DAQmx_DO_DataXferReqCond = hex2dec('2267');
        DAQmx_DO_GenerateOn = hex2dec('2969');
        DAQmx_DO_InvertLines = hex2dec('1133');
        DAQmx_DO_LineStates_DoneState = hex2dec('2968');
        DAQmx_DO_LineStates_PausedState = hex2dec('2967');
        DAQmx_DO_LineStates_StartState = hex2dec('2972');
        DAQmx_DO_LogicFamily = hex2dec('296E');
        DAQmx_DO_MemMapEnable = hex2dec('296B');
        DAQmx_DO_NumLines = hex2dec('2179');
        DAQmx_DO_OutputDriveType = hex2dec('1137');
        DAQmx_DO_Overcurrent_AutoReenable = hex2dec('2A86');
        DAQmx_DO_Overcurrent_Limit = hex2dec('2A85');
        DAQmx_DO_Overcurrent_ReenablePeriod = hex2dec('2A87');
        DAQmx_DO_Tristate = hex2dec('18F3');
        DAQmx_DO_UsbXferReqCount = hex2dec('3003');
        DAQmx_DO_UsbXferReqSize = hex2dec('2A91');
        DAQmx_DO_UseOnlyOnBrdMem = hex2dec('2265');
        DAQmx_DelayFromSampClk_Delay = hex2dec('1317');
        DAQmx_DelayFromSampClk_DelayUnits = hex2dec('1304');
        DAQmx_Dev_AI_BridgeRngs = hex2dec('2FD0');
        DAQmx_Dev_AI_ChargeRngs = hex2dec('3111');
        DAQmx_Dev_AI_Couplings = hex2dec('2994');
        DAQmx_Dev_AI_CurrentIntExcitDiscreteVals = hex2dec('29CB');
        DAQmx_Dev_AI_CurrentRngs = hex2dec('2991');
        DAQmx_Dev_AI_DigFltr_LowpassCutoffFreqDiscreteVals = hex2dec('30C8');
        DAQmx_Dev_AI_DigFltr_LowpassCutoffFreqRangeVals = hex2dec('30C9');
        DAQmx_Dev_AI_FreqRngs = hex2dec('2992');
        DAQmx_Dev_AI_Gains = hex2dec('2993');
        DAQmx_Dev_AI_LowpassCutoffFreqDiscreteVals = hex2dec('2995');
        DAQmx_Dev_AI_LowpassCutoffFreqRangeVals = hex2dec('29CF');
        DAQmx_Dev_AI_MaxMultiChanRate = hex2dec('298D');
        DAQmx_Dev_AI_MaxSingleChanRate = hex2dec('298C');
        DAQmx_Dev_AI_MinRate = hex2dec('298E');
        DAQmx_Dev_AI_NumSampTimingEngines = hex2dec('3163');
        DAQmx_Dev_AI_NumSyncPulseSrcs = hex2dec('3164');
        DAQmx_Dev_AI_PhysicalChans = hex2dec('231E');
        DAQmx_Dev_AI_ResistanceRngs = hex2dec('2A15');
        DAQmx_Dev_AI_SampModes = hex2dec('2FDC');
        DAQmx_Dev_AI_SimultaneousSamplingSupported = hex2dec('298F');
        DAQmx_Dev_AI_SupportedMeasTypes = hex2dec('2FD2');
        DAQmx_Dev_AI_TrigUsage = hex2dec('2986');
        DAQmx_Dev_AI_VoltageIntExcitDiscreteVals = hex2dec('29C9');
        DAQmx_Dev_AI_VoltageIntExcitRangeVals = hex2dec('29CA');
        DAQmx_Dev_AI_VoltageRngs = hex2dec('2990');
        DAQmx_Dev_AO_CurrentRngs = hex2dec('299C');
        DAQmx_Dev_AO_Gains = hex2dec('299D');
        DAQmx_Dev_AO_MaxRate = hex2dec('2997');
        DAQmx_Dev_AO_MinRate = hex2dec('2998');
        DAQmx_Dev_AO_NumSampTimingEngines = hex2dec('3165');
        DAQmx_Dev_AO_NumSyncPulseSrcs = hex2dec('3166');
        DAQmx_Dev_AO_PhysicalChans = hex2dec('231F');
        DAQmx_Dev_AO_SampClkSupported = hex2dec('2996');
        DAQmx_Dev_AO_SampModes = hex2dec('2FDD');
        DAQmx_Dev_AO_SupportedOutputTypes = hex2dec('2FD3');
        DAQmx_Dev_AO_TrigUsage = hex2dec('2987');
        DAQmx_Dev_AO_VoltageRngs = hex2dec('299B');
        DAQmx_Dev_Accessory_ProductNums = hex2dec('2F6E');
        DAQmx_Dev_Accessory_ProductTypes = hex2dec('2F6D');
        DAQmx_Dev_Accessory_SerialNums = hex2dec('2F6F');
        DAQmx_Dev_AnlgTrigSupported = hex2dec('2984');
        DAQmx_Dev_BusType = hex2dec('2326');
        DAQmx_Dev_CI_MaxSize = hex2dec('299F');
        DAQmx_Dev_CI_MaxTimebase = hex2dec('29A0');
        DAQmx_Dev_CI_PhysicalChans = hex2dec('2324');
        DAQmx_Dev_CI_SampClkSupported = hex2dec('299E');
        DAQmx_Dev_CI_SampModes = hex2dec('2FDE');
        DAQmx_Dev_CI_SupportedMeasTypes = hex2dec('2FD4');
        DAQmx_Dev_CI_TrigUsage = hex2dec('298A');
        DAQmx_Dev_CO_MaxSize = hex2dec('29A1');
        DAQmx_Dev_CO_MaxTimebase = hex2dec('29A2');
        DAQmx_Dev_CO_PhysicalChans = hex2dec('2325');
        DAQmx_Dev_CO_SampClkSupported = hex2dec('2F5B');
        DAQmx_Dev_CO_SampModes = hex2dec('2FDF');
        DAQmx_Dev_CO_SupportedOutputTypes = hex2dec('2FD5');
        DAQmx_Dev_CO_TrigUsage = hex2dec('298B');
        DAQmx_Dev_Chassis_ModuleDevNames = hex2dec('29B6');
        DAQmx_Dev_CompactDAQ_ChassisDevName = hex2dec('29B7');
        DAQmx_Dev_CompactDAQ_SlotNum = hex2dec('29B8');
        DAQmx_Dev_CompactRIO_ChassisDevName = hex2dec('3161');
        DAQmx_Dev_CompactRIO_SlotNum = hex2dec('3162');
        DAQmx_Dev_DI_Lines = hex2dec('2320');
        DAQmx_Dev_DI_MaxRate = hex2dec('2999');
        DAQmx_Dev_DI_NumSampTimingEngines = hex2dec('3167');
        DAQmx_Dev_DI_Ports = hex2dec('2321');
        DAQmx_Dev_DI_TrigUsage = hex2dec('2988');
        DAQmx_Dev_DO_Lines = hex2dec('2322');
        DAQmx_Dev_DO_MaxRate = hex2dec('299A');
        DAQmx_Dev_DO_NumSampTimingEngines = hex2dec('3168');
        DAQmx_Dev_DO_Ports = hex2dec('2323');
        DAQmx_Dev_DO_TrigUsage = hex2dec('2989');
        DAQmx_Dev_DigTrigSupported = hex2dec('2985');
        %********** Device Attributes **********
        DAQmx_Dev_IsSimulated = hex2dec('22CA');
        DAQmx_Dev_NumDMAChans = hex2dec('233C');
        DAQmx_Dev_NumTimeTrigs = hex2dec('3141');
        DAQmx_Dev_NumTimestampEngines = hex2dec('3142');
        DAQmx_Dev_PCI_BusNum = hex2dec('2327');
        DAQmx_Dev_PCI_DevNum = hex2dec('2328');
        DAQmx_Dev_PXI_ChassisNum = hex2dec('2329');
        DAQmx_Dev_PXI_SlotNum = hex2dec('232A');
        DAQmx_Dev_ProductCategory = hex2dec('29A9');
        DAQmx_Dev_ProductNum = hex2dec('231D');
        DAQmx_Dev_ProductType = hex2dec('0631');
        DAQmx_Dev_SerialNum = hex2dec('0632');
        DAQmx_Dev_TCPIP_EthernetIP = hex2dec('2A8C');
        DAQmx_Dev_TCPIP_Hostname = hex2dec('2A8B');
        DAQmx_Dev_TCPIP_WirelessIP = hex2dec('2A8D');
        DAQmx_Dev_TEDS_HWTEDSSupported = hex2dec('2FD6');
        DAQmx_Dev_Terminals = hex2dec('2A40');
        DAQmx_Dev_TimeTrigSupported = hex2dec('301F');
        DAQmx_DigEdge_AdvTrig_DigFltr_Enable = hex2dec('2238');
        DAQmx_DigEdge_AdvTrig_Edge = hex2dec('1360');
        DAQmx_DigEdge_AdvTrig_Src = hex2dec('1362');
        DAQmx_DigEdge_ArmStartTrig_DigFltr_Enable = hex2dec('222D');
        DAQmx_DigEdge_ArmStartTrig_DigFltr_MinPulseWidth = hex2dec('222E');
        DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseRate = hex2dec('2230');
        DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseSrc = hex2dec('222F');
        DAQmx_DigEdge_ArmStartTrig_DigSync_Enable = hex2dec('2231');
        DAQmx_DigEdge_ArmStartTrig_Edge = hex2dec('1415');
        DAQmx_DigEdge_ArmStartTrig_Src = hex2dec('1417');
        DAQmx_DigEdge_RefTrig_DigFltr_Enable = hex2dec('2ED7');
        DAQmx_DigEdge_RefTrig_DigFltr_MinPulseWidth = hex2dec('2ED8');
        DAQmx_DigEdge_RefTrig_DigFltr_TimebaseRate = hex2dec('2EDA');
        DAQmx_DigEdge_RefTrig_DigFltr_TimebaseSrc = hex2dec('2ED9');
        DAQmx_DigEdge_RefTrig_DigSync_Enable = hex2dec('2EDB');
        DAQmx_DigEdge_RefTrig_Edge = hex2dec('1430');
        DAQmx_DigEdge_RefTrig_Src = hex2dec('1434');
        DAQmx_DigEdge_StartTrig_DigFltr_Enable = hex2dec('2223');
        DAQmx_DigEdge_StartTrig_DigFltr_MinPulseWidth = hex2dec('2224');
        DAQmx_DigEdge_StartTrig_DigFltr_TimebaseRate = hex2dec('2226');
        DAQmx_DigEdge_StartTrig_DigFltr_TimebaseSrc = hex2dec('2225');
        DAQmx_DigEdge_StartTrig_DigSync_Enable = hex2dec('2227');
        DAQmx_DigEdge_StartTrig_Edge = hex2dec('1404');
        DAQmx_DigEdge_StartTrig_Src = hex2dec('1407');
        DAQmx_DigEdge_WatchdogExpirTrig_Edge = hex2dec('21A5');
        DAQmx_DigEdge_WatchdogExpirTrig_Src = hex2dec('21A4');
        DAQmx_DigLvl_PauseTrig_DigFltr_Enable = hex2dec('2228');
        DAQmx_DigLvl_PauseTrig_DigFltr_MinPulseWidth = hex2dec('2229');
        DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseRate = hex2dec('222B');
        DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseSrc = hex2dec('222A');
        DAQmx_DigLvl_PauseTrig_DigSync_Enable = hex2dec('222C');
        DAQmx_DigLvl_PauseTrig_Src = hex2dec('1379');
        DAQmx_DigLvl_PauseTrig_When = hex2dec('1380');
        DAQmx_DigPattern_PauseTrig_Pattern = hex2dec('2188');
        DAQmx_DigPattern_PauseTrig_Src = hex2dec('216F');
        DAQmx_DigPattern_PauseTrig_When = hex2dec('2170');
        DAQmx_DigPattern_RefTrig_Pattern = hex2dec('2187');
        DAQmx_DigPattern_RefTrig_Src = hex2dec('1437');
        DAQmx_DigPattern_RefTrig_When = hex2dec('1438');
        DAQmx_DigPattern_StartTrig_Pattern = hex2dec('2186');
        DAQmx_DigPattern_StartTrig_Src = hex2dec('1410');
        DAQmx_DigPattern_StartTrig_When = hex2dec('1411');
        DAQmx_Exported_10MHzRefClk_OutputTerm = hex2dec('226E');
        DAQmx_Exported_20MHzTimebase_OutputTerm = hex2dec('1657');
        %********** Export Signal Attributes **********
        DAQmx_Exported_AIConvClk_OutputTerm = hex2dec('1687');
        DAQmx_Exported_AIConvClk_Pulse_Polarity = hex2dec('1688');
        DAQmx_Exported_AIHoldCmpltEvent_OutputTerm = hex2dec('18ED');
        DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity = hex2dec('18EE');
        DAQmx_Exported_AdvCmpltEvent_Delay = hex2dec('1757');
        DAQmx_Exported_AdvCmpltEvent_OutputTerm = hex2dec('1651');
        DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity = hex2dec('1652');
        DAQmx_Exported_AdvCmpltEvent_Pulse_Width = hex2dec('1654');
        DAQmx_Exported_AdvTrig_OutputTerm = hex2dec('1645');
        DAQmx_Exported_AdvTrig_Pulse_Polarity = hex2dec('1646');
        DAQmx_Exported_AdvTrig_Pulse_Width = hex2dec('1648');
        DAQmx_Exported_AdvTrig_Pulse_WidthUnits = hex2dec('1647');
        DAQmx_Exported_ChangeDetectEvent_OutputTerm = hex2dec('2197');
        DAQmx_Exported_ChangeDetectEvent_Pulse_Polarity = hex2dec('2303');
        DAQmx_Exported_CtrOutEvent_OutputBehavior = hex2dec('174F');
        DAQmx_Exported_CtrOutEvent_OutputTerm = hex2dec('1717');
        DAQmx_Exported_CtrOutEvent_Pulse_Polarity = hex2dec('1718');
        DAQmx_Exported_CtrOutEvent_Toggle_IdleState = hex2dec('186A');
        DAQmx_Exported_DataActiveEvent_Lvl_ActiveLvl = hex2dec('1634');
        DAQmx_Exported_DataActiveEvent_OutputTerm = hex2dec('1633');
        DAQmx_Exported_DividedSampClkTimebase_OutputTerm = hex2dec('21A1');
        DAQmx_Exported_HshkEvent_Delay = hex2dec('22BC');
        DAQmx_Exported_HshkEvent_Interlocked_AssertOnStart = hex2dec('22BE');
        DAQmx_Exported_HshkEvent_Interlocked_AssertedLvl = hex2dec('22BD');
        DAQmx_Exported_HshkEvent_Interlocked_DeassertDelay = hex2dec('22BF');
        DAQmx_Exported_HshkEvent_OutputBehavior = hex2dec('22BB');
        DAQmx_Exported_HshkEvent_OutputTerm = hex2dec('22BA');
        DAQmx_Exported_HshkEvent_Pulse_Polarity = hex2dec('22C0');
        DAQmx_Exported_HshkEvent_Pulse_Width = hex2dec('22C1');
        DAQmx_Exported_PauseTrig_Lvl_ActiveLvl = hex2dec('1616');
        DAQmx_Exported_PauseTrig_OutputTerm = hex2dec('1615');
        DAQmx_Exported_RdyForStartEvent_Lvl_ActiveLvl = hex2dec('1751');
        DAQmx_Exported_RdyForStartEvent_OutputTerm = hex2dec('1609');
        DAQmx_Exported_RdyForXferEvent_DeassertCond = hex2dec('2963');
        DAQmx_Exported_RdyForXferEvent_DeassertCondCustomThreshold = hex2dec('2964');
        DAQmx_Exported_RdyForXferEvent_Lvl_ActiveLvl = hex2dec('22B6');
        DAQmx_Exported_RdyForXferEvent_OutputTerm = hex2dec('22B5');
        DAQmx_Exported_RefTrig_OutputTerm = hex2dec('0590');
        DAQmx_Exported_RefTrig_Pulse_Polarity = hex2dec('0591');
        DAQmx_Exported_SampClkTimebase_OutputTerm = hex2dec('18F9');
        DAQmx_Exported_SampClk_DelayOffset = hex2dec('21C4');
        DAQmx_Exported_SampClk_OutputBehavior = hex2dec('186B');
        DAQmx_Exported_SampClk_OutputTerm = hex2dec('1663');
        DAQmx_Exported_SampClk_Pulse_Polarity = hex2dec('1664');
        DAQmx_Exported_StartTrig_OutputTerm = hex2dec('0584');
        DAQmx_Exported_StartTrig_Pulse_Polarity = hex2dec('0585');
        DAQmx_Exported_SyncPulseEvent_OutputTerm = hex2dec('223C');
        DAQmx_Exported_WatchdogExpiredEvent_OutputTerm = hex2dec('21AA');
        DAQmx_ExtCal_LastTemp = hex2dec('1867');
        DAQmx_ExtCal_RecommendedInterval = hex2dec('1868');
        DAQmx_FieldDAQ_BankDevNames = hex2dec('3178');
        DAQmx_FieldDAQ_DevName = hex2dec('3171');
        DAQmx_FirstSampClk_Offset = hex2dec('31AA');
        DAQmx_FirstSampClk_Timescale = hex2dec('3183');
        DAQmx_FirstSampClk_When = hex2dec('3182');
        DAQmx_FirstSampTimestamp_Enable = hex2dec('3139');
        DAQmx_FirstSampTimestamp_Timescale = hex2dec('313B');
        DAQmx_FirstSampTimestamp_Val = hex2dec('313A');
        DAQmx_HshkTrig_Type = hex2dec('22B7');
        DAQmx_Hshk_DelayAfterXfer = hex2dec('22C2');
        DAQmx_Hshk_SampleInputDataWhen = hex2dec('22C4');
        DAQmx_Hshk_StartCond = hex2dec('22C3');
        DAQmx_Implicit_UnderflowBehavior = hex2dec('2EFD');
        DAQmx_Interlocked_HshkTrig_AssertedLvl = hex2dec('22B9');
        DAQmx_Interlocked_HshkTrig_Src = hex2dec('22B8');
        DAQmx_Logging_FilePath = hex2dec('2EC4');
        DAQmx_Logging_FilePreallocationSize = hex2dec('2FC6');
        DAQmx_Logging_FileWriteSize = hex2dec('2FC3');
        DAQmx_Logging_Mode = hex2dec('2EC5');
        DAQmx_Logging_Pause = hex2dec('2FE3');
        DAQmx_Logging_SampsPerFile = hex2dec('2FE4');
        DAQmx_Logging_TDMS_GroupName = hex2dec('2EC6');
        DAQmx_Logging_TDMS_Operation = hex2dec('2EC7');
        DAQmx_MasterTimebase_Rate = hex2dec('1495');
        DAQmx_MasterTimebase_Src = hex2dec('1343');
        DAQmx_OnDemand_SimultaneousAOEnable = hex2dec('21A0');
        DAQmx_PauseTrig_Term = hex2dec('2F20');
        DAQmx_PauseTrig_Type = hex2dec('1366');
        DAQmx_PersistedChan_AllowInteractiveDeletion = hex2dec('22D2');
        DAQmx_PersistedChan_AllowInteractiveEditing = hex2dec('22D1');
        %********** Persisted Channel Attributes **********
        DAQmx_PersistedChan_Author = hex2dec('22D0');
        DAQmx_PersistedScale_AllowInteractiveDeletion = hex2dec('22D6');
        DAQmx_PersistedScale_AllowInteractiveEditing = hex2dec('22D5');
        %********** Persisted Scale Attributes **********
        DAQmx_PersistedScale_Author = hex2dec('22D4');
        DAQmx_PersistedTask_AllowInteractiveDeletion = hex2dec('22CE');
        DAQmx_PersistedTask_AllowInteractiveEditing = hex2dec('22CD');
        %********** Persisted Task Attributes **********
        DAQmx_PersistedTask_Author = hex2dec('22CC');
        DAQmx_PhysicalChanName = hex2dec('18F5');
        DAQmx_PhysicalChan_AI_InputSrcs = hex2dec('2FD8');
        DAQmx_PhysicalChan_AI_PowerControl_Enable = hex2dec('316D');
        DAQmx_PhysicalChan_AI_PowerControl_Type = hex2dec('316E');
        DAQmx_PhysicalChan_AI_PowerControl_Voltage = hex2dec('316C');
        DAQmx_PhysicalChan_AI_SensorPower_OpenChan = hex2dec('317C');
        DAQmx_PhysicalChan_AI_SensorPower_Overcurrent = hex2dec('317D');
        DAQmx_PhysicalChan_AI_SensorPower_Types = hex2dec('3179');
        DAQmx_PhysicalChan_AI_SensorPower_VoltageRangeVals = hex2dec('317A');
        %********** Physical Channel Attributes **********
        DAQmx_PhysicalChan_AI_SupportedMeasTypes = hex2dec('2FD7');
        DAQmx_PhysicalChan_AI_TermCfgs = hex2dec('2342');
        DAQmx_PhysicalChan_AO_ManualControlAmplitude = hex2dec('2A1F');
        DAQmx_PhysicalChan_AO_ManualControlEnable = hex2dec('2A1E');
        DAQmx_PhysicalChan_AO_ManualControlFreq = hex2dec('2A20');
        DAQmx_PhysicalChan_AO_ManualControl_ShortDetected = hex2dec('2EC3');
        DAQmx_PhysicalChan_AO_SupportedOutputTypes = hex2dec('2FD9');
        DAQmx_PhysicalChan_AO_SupportedPowerUpOutputTypes = hex2dec('304E');
        DAQmx_PhysicalChan_AO_TermCfgs = hex2dec('29A3');
        DAQmx_PhysicalChan_CI_SupportedMeasTypes = hex2dec('2FDA');
        DAQmx_PhysicalChan_CO_SupportedOutputTypes = hex2dec('2FDB');
        DAQmx_PhysicalChan_DI_ChangeDetectSupported = hex2dec('29A6');
        DAQmx_PhysicalChan_DI_PortWidth = hex2dec('29A4');
        DAQmx_PhysicalChan_DI_SampClkSupported = hex2dec('29A5');
        DAQmx_PhysicalChan_DI_SampModes = hex2dec('2FE0');
        DAQmx_PhysicalChan_DO_PortWidth = hex2dec('29A7');
        DAQmx_PhysicalChan_DO_SampClkSupported = hex2dec('29A8');
        DAQmx_PhysicalChan_DO_SampModes = hex2dec('2FE1');
        DAQmx_PhysicalChan_TEDS_BitStream = hex2dec('21DF');
        DAQmx_PhysicalChan_TEDS_MfgID = hex2dec('21DA');
        DAQmx_PhysicalChan_TEDS_ModelNum = hex2dec('21DB');
        DAQmx_PhysicalChan_TEDS_SerialNum = hex2dec('21DC');
        DAQmx_PhysicalChan_TEDS_TemplateIDs = hex2dec('228F');
        DAQmx_PhysicalChan_TEDS_VersionLetter = hex2dec('21DE');
        DAQmx_PhysicalChan_TEDS_VersionNum = hex2dec('21DD');
        DAQmx_Pwr_Current_DevScalingCoeff = hex2dec('31DA');
        DAQmx_Pwr_Current_Setpoint = hex2dec('31D5');
        DAQmx_Pwr_IdleOutputBehavior = hex2dec('31D8');
        DAQmx_Pwr_OutputEnable = hex2dec('31D6');
        DAQmx_Pwr_OutputState = hex2dec('31D7');
        DAQmx_Pwr_RemoteSense = hex2dec('31DB');
        DAQmx_Pwr_Voltage_DevScalingCoeff = hex2dec('31D9');
        DAQmx_Pwr_Voltage_Setpoint = hex2dec('31D4');
        DAQmx_Read_AccessoryInsertionOrRemovalDetected = hex2dec('2F70');
        DAQmx_Read_AutoStart = hex2dec('1826');
        DAQmx_Read_AvailSampPerChan = hex2dec('1223');
        DAQmx_Read_ChangeDetect_HasOverflowed = hex2dec('2194');
        DAQmx_Read_ChannelsToRead = hex2dec('1823');
        DAQmx_Read_CommonModeRangeErrorChans = hex2dec('2A99');
        DAQmx_Read_CommonModeRangeErrorChansExist = hex2dec('2A98');
        DAQmx_Read_CurrReadPos = hex2dec('1221');
        DAQmx_Read_DevsWithInsertedOrRemovedAccessories = hex2dec('2F71');
        DAQmx_Read_DigitalLines_BytesPerChan = hex2dec('217C');
        DAQmx_Read_ExcitFaultChans = hex2dec('3089');
        DAQmx_Read_ExcitFaultChansExist = hex2dec('3088');
        DAQmx_Read_InputLimitsFaultChans = hex2dec('3190');
        DAQmx_Read_InputLimitsFaultChansExist = hex2dec('318F');
        DAQmx_Read_NumChans = hex2dec('217B');
        DAQmx_Read_Offset = hex2dec('190B');
        DAQmx_Read_OpenChans = hex2dec('3101');
        DAQmx_Read_OpenChansDetails = hex2dec('3102');
        DAQmx_Read_OpenChansExist = hex2dec('3100');
        DAQmx_Read_OpenCurrentLoopChans = hex2dec('2A0A');
        DAQmx_Read_OpenCurrentLoopChansExist = hex2dec('2A09');
        DAQmx_Read_OpenThrmcplChans = hex2dec('2A97');
        DAQmx_Read_OpenThrmcplChansExist = hex2dec('2A96');
        DAQmx_Read_OverWrite = hex2dec('1211');
        DAQmx_Read_OvercurrentChans = hex2dec('29E7');
        DAQmx_Read_OvercurrentChansExist = hex2dec('29E6');
        DAQmx_Read_OverloadedChans = hex2dec('2175');
        DAQmx_Read_OverloadedChansExist = hex2dec('2174');
        DAQmx_Read_OvertemperatureChans = hex2dec('3082');
        DAQmx_Read_OvertemperatureChansExist = hex2dec('3081');
        DAQmx_Read_PLL_UnlockedChans = hex2dec('3119');
        DAQmx_Read_PLL_UnlockedChansExist = hex2dec('3118');
        DAQmx_Read_PowerSupplyFaultChans = hex2dec('3193');
        DAQmx_Read_PowerSupplyFaultChansExist = hex2dec('3192');
        DAQmx_Read_RawDataWidth = hex2dec('217A');
        DAQmx_Read_ReadAllAvailSamp = hex2dec('1215');
        %********** Read Attributes **********
        DAQmx_Read_RelativeTo = hex2dec('190A');
        DAQmx_Read_SleepTime = hex2dec('22B0');
        DAQmx_Read_Sync_UnlockedChans = hex2dec('313E');
        DAQmx_Read_Sync_UnlockedChansExist = hex2dec('313D');
        DAQmx_Read_TotalSampPerChanAcquired = hex2dec('192A');
        DAQmx_Read_WaitMode = hex2dec('2232');
        %********** Real-Time Attributes **********
        DAQmx_RealTime_ConvLateErrorsToWarnings = hex2dec('22EE');
        DAQmx_RealTime_NumOfWarmupIters = hex2dec('22ED');
        DAQmx_RealTime_ReportMissedSamp = hex2dec('2319');
        DAQmx_RealTime_WaitForNextSampClkWaitMode = hex2dec('22EF');
        DAQmx_RealTime_WriteRecoveryMode = hex2dec('231A');
        DAQmx_RefClk_Rate = hex2dec('1315');
        DAQmx_RefClk_Src = hex2dec('1316');
        DAQmx_RefTrig_AutoTrigEnable = hex2dec('2EC1');
        DAQmx_RefTrig_AutoTriggered = hex2dec('2EC2');
        DAQmx_RefTrig_Delay = hex2dec('1483');
        DAQmx_RefTrig_MaxNumTrigsToDetect = hex2dec('3120');
        DAQmx_RefTrig_PretrigSamples = hex2dec('1445');
        DAQmx_RefTrig_RetriggerWin = hex2dec('311F');
        DAQmx_RefTrig_Retriggerable = hex2dec('311D');
        DAQmx_RefTrig_Term = hex2dec('2F1F');
        DAQmx_RefTrig_TimestampEnable = hex2dec('312E');
        DAQmx_RefTrig_TimestampTimescale = hex2dec('3130');
        DAQmx_RefTrig_TimestampVal = hex2dec('312F');
        DAQmx_RefTrig_TrigWin = hex2dec('311E');
        DAQmx_RefTrig_Type = hex2dec('1419');
        DAQmx_RemoteSenseErrorChans = hex2dec('31DE');
        DAQmx_RemoteSenseErrorChansExist = hex2dec('31DD');
        DAQmx_ReverseVoltageErrorChans = hex2dec('31E7');
        DAQmx_ReverseVoltageErrorChansExist = hex2dec('31E6');
        DAQmx_SampClkTimebase_Term = hex2dec('2F1C');
        DAQmx_SampClk_ActiveEdge = hex2dec('1301');
        DAQmx_SampClk_DigFltr_Enable = hex2dec('221E');
        DAQmx_SampClk_DigFltr_MinPulseWidth = hex2dec('221F');
        DAQmx_SampClk_DigFltr_TimebaseRate = hex2dec('2221');
        DAQmx_SampClk_DigFltr_TimebaseSrc = hex2dec('2220');
        DAQmx_SampClk_DigSync_Enable = hex2dec('2222');
        DAQmx_SampClk_MaxRate = hex2dec('22C8');
        DAQmx_SampClk_OverrunBehavior = hex2dec('2EFC');
        DAQmx_SampClk_Rate = hex2dec('1344');
        DAQmx_SampClk_Src = hex2dec('1852');
        DAQmx_SampClk_Term = hex2dec('2F1B');
        DAQmx_SampClk_TimebaseDiv = hex2dec('18EB');
        DAQmx_SampClk_Timebase_ActiveEdge = hex2dec('18EC');
        DAQmx_SampClk_Timebase_MasterTimebaseDiv = hex2dec('1305');
        DAQmx_SampClk_Timebase_Rate = hex2dec('1303');
        DAQmx_SampClk_Timebase_Src = hex2dec('1308');
        DAQmx_SampClk_UnderflowBehavior = hex2dec('2961');
        DAQmx_SampClk_WriteWfm_UseInitialWfmDT = hex2dec('30FC');
        %********** Timing Attributes **********
        DAQmx_SampQuant_SampMode = hex2dec('1300');
        DAQmx_SampQuant_SampPerChan = hex2dec('1310');
        DAQmx_SampTimingEngine = hex2dec('2A26');
        DAQmx_SampTimingType = hex2dec('1347');
        %********** Scale Attributes **********
        DAQmx_Scale_Descr = hex2dec('1226');
        DAQmx_Scale_Lin_Slope = hex2dec('1227');
        DAQmx_Scale_Lin_YIntercept = hex2dec('1228');
        DAQmx_Scale_Map_PreScaledMax = hex2dec('1231');
        DAQmx_Scale_Map_PreScaledMin = hex2dec('1232');
        DAQmx_Scale_Map_ScaledMax = hex2dec('1229');
        DAQmx_Scale_Map_ScaledMin = hex2dec('1230');
        DAQmx_Scale_Poly_ForwardCoeff = hex2dec('1234');
        DAQmx_Scale_Poly_ReverseCoeff = hex2dec('1235');
        DAQmx_Scale_PreScaledUnits = hex2dec('18F7');
        DAQmx_Scale_ScaledUnits = hex2dec('191B');
        DAQmx_Scale_Table_PreScaledVals = hex2dec('1237');
        DAQmx_Scale_Table_ScaledVals = hex2dec('1236');
        DAQmx_Scale_Type = hex2dec('1929');
        DAQmx_SelfCal_LastTemp = hex2dec('1864');
        %********** Calibration Info Attributes **********
        DAQmx_SelfCal_Supported = hex2dec('1860');
        DAQmx_StartTrig_Delay = hex2dec('1856');
        DAQmx_StartTrig_DelayUnits = hex2dec('18C8');
        DAQmx_StartTrig_MaxNumTrigsToDetect = hex2dec('311C');
        DAQmx_StartTrig_RetriggerWin = hex2dec('311B');
        DAQmx_StartTrig_Retriggerable = hex2dec('190F');
        DAQmx_StartTrig_Term = hex2dec('2F1E');
        DAQmx_StartTrig_Timescale = hex2dec('3036');
        DAQmx_StartTrig_TimestampEnable = hex2dec('314A');
        DAQmx_StartTrig_TimestampTimescale = hex2dec('312D');
        DAQmx_StartTrig_TimestampVal = hex2dec('314B');
        DAQmx_StartTrig_TrigWhen = hex2dec('304D');
        DAQmx_StartTrig_TrigWin = hex2dec('311A');
        %********** Trigger Attributes **********
        DAQmx_StartTrig_Type = hex2dec('1393');
        DAQmx_SwitchChan_AnlgBusSharingEnable = hex2dec('2F9E');
        DAQmx_SwitchChan_Bandwidth = hex2dec('0640');
        DAQmx_SwitchChan_Impedance = hex2dec('0641');
        DAQmx_SwitchChan_MaxACCarryCurrent = hex2dec('0648');
        DAQmx_SwitchChan_MaxACCarryPwr = hex2dec('0642');
        DAQmx_SwitchChan_MaxACSwitchCurrent = hex2dec('0646');
        DAQmx_SwitchChan_MaxACSwitchPwr = hex2dec('0644');
        DAQmx_SwitchChan_MaxACVoltage = hex2dec('0651');
        DAQmx_SwitchChan_MaxDCCarryCurrent = hex2dec('0647');
        DAQmx_SwitchChan_MaxDCCarryPwr = hex2dec('0643');
        DAQmx_SwitchChan_MaxDCSwitchCurrent = hex2dec('0645');
        DAQmx_SwitchChan_MaxDCSwitchPwr = hex2dec('0649');
        DAQmx_SwitchChan_MaxDCVoltage = hex2dec('0650');
        %********** Switch Channel Attributes **********
        DAQmx_SwitchChan_Usage = hex2dec('18E4');
        DAQmx_SwitchChan_WireMode = hex2dec('18E5');
        DAQmx_SwitchDev_AutoConnAnlgBus = hex2dec('17DA');
        DAQmx_SwitchDev_NumColumns = hex2dec('18EA');
        DAQmx_SwitchDev_NumRelays = hex2dec('18E6');
        DAQmx_SwitchDev_NumRows = hex2dec('18E9');
        DAQmx_SwitchDev_NumSwitchChans = hex2dec('18E8');
        DAQmx_SwitchDev_PwrDownLatchRelaysAfterSettling = hex2dec('22DB');
        DAQmx_SwitchDev_RelayList = hex2dec('17DC');
        DAQmx_SwitchDev_Settled = hex2dec('1243');
        %********** Switch Device Attributes **********
        DAQmx_SwitchDev_SettlingTime = hex2dec('1244');
        DAQmx_SwitchDev_SwitchChanList = hex2dec('18E7');
        DAQmx_SwitchDev_Temperature = hex2dec('301A');
        DAQmx_SwitchDev_Topology = hex2dec('193D');
        %********** Switch Scan Attributes **********
        DAQmx_SwitchScan_BreakMode = hex2dec('1247');
        DAQmx_SwitchScan_RepeatMode = hex2dec('1248');
        DAQmx_SwitchScan_WaitingForAdv = hex2dec('17D9');
        DAQmx_SyncClk_Interval = hex2dec('2F7E');
        DAQmx_SyncPulse_MinDelayToStart = hex2dec('223F');
        DAQmx_SyncPulse_ResetDelay = hex2dec('2F7D');
        DAQmx_SyncPulse_ResetTime = hex2dec('2F7C');
        DAQmx_SyncPulse_Src = hex2dec('223D');
        DAQmx_SyncPulse_SyncTime = hex2dec('223E');
        DAQmx_SyncPulse_Term = hex2dec('2F85');
        DAQmx_SyncPulse_Time_Timescale = hex2dec('3138');
        DAQmx_SyncPulse_Time_When = hex2dec('3137');
        DAQmx_SyncPulse_Type = hex2dec('3136');
        DAQmx_Sys_DevNames = hex2dec('193B');
        %********** System Attributes **********
        DAQmx_Sys_GlobalChans = hex2dec('1265');
        DAQmx_Sys_NIDAQMajorVersion = hex2dec('1272');
        DAQmx_Sys_NIDAQMinorVersion = hex2dec('1923');
        DAQmx_Sys_NIDAQUpdateVersion = hex2dec('2F22');
        DAQmx_Sys_Scales = hex2dec('1266');
        DAQmx_Sys_Tasks = hex2dec('1267');
        DAQmx_Task_Channels = hex2dec('1273');
        DAQmx_Task_Complete = hex2dec('1274');
        DAQmx_Task_Devices = hex2dec('230E');
        %********** Task Attributes **********
        DAQmx_Task_Name = hex2dec('1276');
        DAQmx_Task_NumChans = hex2dec('2181');
        DAQmx_Task_NumDevices = hex2dec('29BA');
        DAQmx_Trigger_SyncType = hex2dec('2F80');
        DAQmx_Val_100MHzTimebase = int32(15857);
        DAQmx_Val_10MHzRefClock = int32(12536);
        DAQmx_Val_20MHzTimebase = int32(12537);
        DAQmx_Val_20MHzTimebaseClock = int32(12486);
        %*** Values for DAQmx_AI_ResistanceCfg ***
        %*** Value set ResistanceConfiguration ***
        DAQmx_Val_2Wire = int32(2);
        %*** Values for DAQmx_DI_LogicFamily ***
        %*** Values for DAQmx_DO_LogicFamily ***
        %*** Value set LogicFamily ***
        DAQmx_Val_2point5V = int32(14620);
        DAQmx_Val_3Wire = int32(3);
        DAQmx_Val_3point3V = int32(14621);
        %*** Values for DAQmx_AI_ACExcit_WireMode ***
        %*** Value set ACExcitWireMode ***
        DAQmx_Val_4Wire = int32(4);
        DAQmx_Val_5V = int32(14619);
        DAQmx_Val_5Wire = int32(5);
        DAQmx_Val_6Wire = int32(6);
        DAQmx_Val_80MHzTimebase = int32(14636);
        DAQmx_Val_8MHzTimebase = int32(16023);
        %*** Value set for shunt resistor select for Strain and Bridge Shunt Calibration functions ***
        DAQmx_Val_A = int32(12513);
        %*** Values for DAQmx_AI_Coupling ***
        %*** Value set Coupling1 ***
        DAQmx_Val_AC = int32(10045);
        %*** Values for DAQmx_CI_Encoder_ZIndexPhase ***
        %*** Value set EncoderZIndexPhase1 ***
        DAQmx_Val_AHighBHigh = int32(10040);
        DAQmx_Val_AHighBLow = int32(10041);
        %*** Values for DAQmx_ChanType ***
        %*** Value set ChannelType ***
        DAQmx_Val_AI = int32(10100);
        %*** Value set Signal ***
        DAQmx_Val_AIConvertClock = int32(12484);
        DAQmx_Val_AIHoldCmpltEvent = int32(12493);
        DAQmx_Val_ALowBHigh = int32(10042);
        DAQmx_Val_ALowBLow = int32(10043);
        %*** Values for DAQmx_AO_FuncGen_ModulationType ***
        %*** Value set ModulationType ***
        DAQmx_Val_AM = int32(14756);
        DAQmx_Val_AO = int32(10102);
        DAQmx_Val_AOSeries = int32(14647);
        DAQmx_Val_AandB = int32(12515);
        %*** Values for DAQmx_AnlgLvl_PauseTrig_When ***
        %*** Value set ActiveLevel ***
        DAQmx_Val_AboveLvl = int32(10093);
        %*** Values for DAQmx_AI_Accel_Units ***
        %*** Value set AccelUnits2 ***
        DAQmx_Val_AccelUnit_g = int32(10186);
        DAQmx_Val_Acceleration_4WireDCVoltage = int32(16106);
        DAQmx_Val_Acceleration_Charge = int32(16104);
        DAQmx_Val_Accelerometer = int32(10356);
        %*** Values for the everyNsamplesEventType parameter of DAQmxRegisterEveryNSamplesEvent ***
        DAQmx_Val_Acquired_Into_Buffer = int32(1);
        DAQmx_Val_Action_Cancel = int32(1);
        %*** Values for the Action paramter of DAQmxCloseExtCal ***
        DAQmx_Val_Action_Commit = int32(0);
        %*** Values for DAQmx_DO_OutputDriveType ***
        %*** Value set DigitalDriveType ***
        DAQmx_Val_ActiveDrive = int32(12573);
        %*** Values for DAQmx_Exported_AIConvClk_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_SampClk_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_AdvTrig_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_PauseTrig_Lvl_ActiveLvl ***
        %*** Values for DAQmx_Exported_RefTrig_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_StartTrig_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity ***
        %*** Values for DAQmx_Exported_ChangeDetectEvent_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_CtrOutEvent_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_HshkEvent_Pulse_Polarity ***
        %*** Values for DAQmx_Exported_RdyForXferEvent_Lvl_ActiveLvl ***
        %*** Values for DAQmx_Exported_DataActiveEvent_Lvl_ActiveLvl ***
        %*** Values for DAQmx_Exported_RdyForStartEvent_Lvl_ActiveLvl ***
        %*** Value set Polarity2 ***
        DAQmx_Val_ActiveHigh = int32(10095);
        DAQmx_Val_ActiveLow = int32(10096);
        DAQmx_Val_AdvCmpltEvent = int32(12492);
        %*** Values for the Trigger ID parameter of DAQmxSendSoftwareTrigger ***
        DAQmx_Val_AdvanceTrigger = int32(12488);
        %*** Values for DAQmx_Write_RegenMode ***
        %*** Value set RegenerationMode1 ***
        DAQmx_Val_AllowRegen = int32(10097);
        %*** Values for DAQmx_AI_Current_Units ***
        %*** Values for DAQmx_AI_Current_ACRMS_Units ***
        %*** Values for DAQmx_AO_Current_Units ***
        %*** Value set CurrentUnits1 ***
        DAQmx_Val_Amps = int32(10342);
        %*** Values for DAQmx_RefTrig_Type ***
        %*** Value set TriggerType8 ***
        DAQmx_Val_AnlgEdge = int32(10099);
        %*** Values for DAQmx_PauseTrig_Type ***
        %*** Value set TriggerType6 ***
        DAQmx_Val_AnlgLvl = int32(10101);
        DAQmx_Val_AnlgMultiEdge = int32(16108);
        DAQmx_Val_AnlgWin = int32(10103);
        DAQmx_Val_ArmStartTrigger = int32(14641);
        %*** Value for the Timeout parameter of DAQmxWaitUntilTaskDone
        %*** Value for the Number of Samples per Channel parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16,
        %    DAQmxReadBinaryI32, DAQmxReadBinaryU32, DAQmxReadDigitalU8, DAQmxReadDigitalU32,
        %    DAQmxReadDigitalLines, DAQmxReadCounterF64, DAQmxReadCounterU32 and DAQmxReadRaw ***
        DAQmx_Val_Auto = int32(-1);
        %*** Values for DAQmx_AI_ADCTimingMode ***
        %*** Value set ADCTimingMode ***
        DAQmx_Val_Automatic = int32(16097);
        DAQmx_Val_B = int32(12514);
        DAQmx_Val_BSeriesDAQ = int32(14662);
        DAQmx_Val_B_Type_TC = int32(10047);
        DAQmx_Val_Bandpass = int32(16073);
        DAQmx_Val_Bar = int32(15880);
        DAQmx_Val_BelowLvl = int32(10107);
        DAQmx_Val_Bessel = int32(16153);
        DAQmx_Val_Best50HzRejection = int32(14713);
        DAQmx_Val_Best60HzRejection = int32(14714);
        DAQmx_Val_BipolarDC = int32(16147);
        %*** Values for the Coupling Types parameter - set of coupling types a device may support
        %*** Values for CouplingTypeBits
        DAQmx_Val_Bit_CouplingTypes_AC = (bitshift(int32(1),0));
        DAQmx_Val_Bit_CouplingTypes_DC = (bitshift(int32(1),1));
        DAQmx_Val_Bit_CouplingTypes_Ground = (bitshift(int32(1),2));
        DAQmx_Val_Bit_CouplingTypes_HFReject = (bitshift(int32(1),3));
        DAQmx_Val_Bit_CouplingTypes_LFReject = (bitshift(int32(1),4));
        DAQmx_Val_Bit_CouplingTypes_NoiseReject = (bitshift(int32(1),5));
        DAQmx_Val_Bit_TermCfg_Diff = (bitshift(int32(1),2));
        DAQmx_Val_Bit_TermCfg_NRSE = (bitshift(int32(1),1));
        DAQmx_Val_Bit_TermCfg_PseudoDIFF = (bitshift(int32(1),3));
        %*** Values for DAQmx_PhysicalChan_AI_TermCfgs and DAQmx_PhysicalChan_AO_TermCfgs
        %*** Value set TerminalConfigurationBits ***
        DAQmx_Val_Bit_TermCfg_RSE = (bitshift(int32(1),0));
        %*** Values for the Trigger Usage parameter - set of trigger types a device may support
        %*** Values for TriggerUsageTypeBits
        DAQmx_Val_Bit_TriggerUsageTypes_Advance = (bitshift(int32(1),0));
        DAQmx_Val_Bit_TriggerUsageTypes_ArmStart = (bitshift(int32(1),5));
        DAQmx_Val_Bit_TriggerUsageTypes_Handshake = (bitshift(int32(1),4));
        DAQmx_Val_Bit_TriggerUsageTypes_Pause = (bitshift(int32(1),1));
        DAQmx_Val_Bit_TriggerUsageTypes_Reference = (bitshift(int32(1),2));
        DAQmx_Val_Bit_TriggerUsageTypes_Start = (bitshift(int32(1),3));
        %*** Values for DAQmx_AI_ResolutionUnits ***
        %*** Values for DAQmx_AO_ResolutionUnits ***
        %*** Value set ResolutionType1 ***
        DAQmx_Val_Bits = int32(10109);
        DAQmx_Val_BreakBeforeMake = int32(10110);
        DAQmx_Val_Brickwall = int32(16155);
        DAQmx_Val_Bridge = int32(15908);
        %*** Values for DAQmx_AI_Thrmcpl_CJCSrc ***
        %*** Value set CJCSource1 ***
        DAQmx_Val_BuiltIn = int32(10200);
        DAQmx_Val_BurstHandshake = int32(12548);
        DAQmx_Val_Butterworth = int32(16076);
        DAQmx_Val_CI = int32(10131);
        DAQmx_Val_CO = int32(10132);
        DAQmx_Val_CSeriesModule = int32(14659);
        DAQmx_Val_CartesianShearStrainXY = int32(15976);
        DAQmx_Val_CartesianStrainX = int32(15974);
        DAQmx_Val_CartesianStrainY = int32(15975);
        %*** Value for the Terminal Config parameter of DAQmxCreateAIVoltageChan, DAQmxCreateAICurrentChan and DAQmxCreateAIVoltageChanWithExcit ***
        DAQmx_Val_Cfg_Default = int32(-1);
        DAQmx_Val_Chan = int32(10113);
        DAQmx_Val_ChanForAllLines = int32(1);
        %*** Values for the Line Grouping parameter of DAQmxCreateDIChan and DAQmxCreateDOChan ***
        DAQmx_Val_ChanPerLine = int32(0);
        DAQmx_Val_ChangeDetection = int32(12504);
        DAQmx_Val_ChangeDetectionEvent = int32(12511);
        DAQmx_Val_ChannelCurrent = int32(1);
        DAQmx_Val_ChannelHighImpedance = int32(2);
        %*** Value set for the channelType parameter of DAQmxSetAnalogPowerUpStates & DAQmxGetAnalogPowerUpStates ***
        DAQmx_Val_ChannelVoltage = int32(0);
        DAQmx_Val_Charge = int32(16105);
        DAQmx_Val_ClearExpiration = int32(1);
        DAQmx_Val_Closed = int32(10438);
        %*** Values for DAQmx_AI_Filter_Response ***
        %*** Values for DAQmx_CI_Filter_Response ***
        %*** Value set FilterResponse1 ***
        DAQmx_Val_Comb = int32(16152);
        DAQmx_Val_CompactDAQ = int32(14637);
        DAQmx_Val_CompactDAQChassis = int32(14658);
        DAQmx_Val_CompactRIO = int32(16143);
        DAQmx_Val_CompactRIOChassis = int32(16144);
        DAQmx_Val_ConstVal = int32(10116);
        DAQmx_Val_ConstantCurrent = int32(15501);
        %*** Values for DAQmx_AI_DigFltr_Response ***
        %*** Value set FilterResponse ***
        DAQmx_Val_ConstantGroupDelay = int32(16075);
        %*** Values for DAQmx_Pwr_OutputState ***
        %*** Value set PowerOutputState ***
        DAQmx_Val_ConstantVoltage = int32(15500);
        DAQmx_Val_Cont = int32(10117);
        DAQmx_Val_ContSamps = int32(10123);
        %*** Values for DAQmx_AI_Charge_Units ***
        %*** Value set ChargeUnits ***
        DAQmx_Val_Coulombs = int32(16102);
        DAQmx_Val_CountDown = int32(10124);
        %*** Values for DAQmx_CI_MeasType ***
        %*** Values for DAQmx_Dev_CI_SupportedMeasTypes ***
        %*** Values for DAQmx_PhysicalChan_CI_SupportedMeasTypes ***
        %*** Value set CIMeasurementType ***
        DAQmx_Val_CountEdges = int32(10125);
        %*** Values for DAQmx_CI_CountEdges_Dir ***
        %*** Value set CountDirection1 ***
        DAQmx_Val_CountUp = int32(10128);
        DAQmx_Val_CounterOutputEvent = int32(12494);
        DAQmx_Val_Create = int32(15848);
        DAQmx_Val_CreateOrReplace = int32(15847);
        DAQmx_Val_CurrReadPos = int32(10425);
        DAQmx_Val_CurrWritePos = int32(10430);
        DAQmx_Val_Current = int32(10134);
        DAQmx_Val_CurrentRMS = int32(10351);
        DAQmx_Val_Custom = int32(10137);
        DAQmx_Val_DC = int32(10050);
        DAQmx_Val_DI = int32(10151);
        %*** Values for DAQmx_AI_DataXferMech ***
        %*** Values for DAQmx_AO_DataXferMech ***
        %*** Values for DAQmx_DI_DataXferMech ***
        %*** Values for DAQmx_DO_DataXferMech ***
        %*** Values for DAQmx_CI_DataXferMech ***
        %*** Values for DAQmx_CO_DataXferMech ***
        %*** Value set DataTransferMechanism ***
        DAQmx_Val_DMA = int32(10054);
        DAQmx_Val_DO = int32(10153);
        %*** Value for the Shunt Resistor Location parameter of DAQmxCreateAICurrentChan ***
        DAQmx_Val_Default = int32(-1);
        %*** Value set for the Units parameter of DAQmxCreateAIThrmcplChan, DAQmxCreateAIRTDChan, DAQmxCreateAIThrmstrChanIex, DAQmxCreateAIThrmstrChanVex and DAQmxCreateAITempBuiltInSensorChan ***
        DAQmx_Val_DegC = int32(10143);
        DAQmx_Val_DegF = int32(10144);
        DAQmx_Val_DegR = int32(10145);
        %*** Values for DAQmx_AI_RVDT_Units ***
        %*** Value set AngleUnits1 ***
        DAQmx_Val_Degrees = int32(10146);
        DAQmx_Val_DegreesPerSecond = int32(16082);
        DAQmx_Val_DeltaRosette = int32(15969);
        %*** Value set for terminal configuration for 4463 calibration functions ***
        DAQmx_Val_Diff = int32(10106);
        DAQmx_Val_DigEdge = int32(10150);
        DAQmx_Val_DigLvl = int32(10152);
        DAQmx_Val_DigPattern = int32(10398);
        DAQmx_Val_DigitalIO = int32(14648);
        DAQmx_Val_Disabled = int32(16146);
        DAQmx_Val_DoNotAllowRegen = int32(10158);
        %*** Values for the Signal Modifiers parameter of DAQmxConnectTerms ***/
        DAQmx_Val_DoNotInvertPolarity = int32(0);
        DAQmx_Val_DoNotOverwriteUnreadSamps = int32(10159);
        DAQmx_Val_DoNotWrite = int32(12540);
        DAQmx_Val_DutyCycle = int32(16070);
        DAQmx_Val_DynAvg = int32(16065);
        DAQmx_Val_DynamicSignalAcquisition = int32(14649);
        DAQmx_Val_ESeriesDAQ = int32(14642);
        DAQmx_Val_E_Type_TC = int32(10055);
        DAQmx_Val_Elliptical = int32(16077);
        DAQmx_Val_Enabled = int32(16145);
        %*** Values for DAQmx_AnlgWin_StartTrig_When ***
        %*** Values for DAQmx_AnlgWin_RefTrig_When ***
        %*** Value set WindowTriggerCondition1 ***
        DAQmx_Val_EnteringWin = int32(10163);
        DAQmx_Val_EverySample = int32(10164);
        DAQmx_Val_ExtControlled = int32(10326);
        DAQmx_Val_External = int32(10167);
        DAQmx_Val_FM = int32(14757);
        DAQmx_Val_Falling = int32(10171);
        DAQmx_Val_FallingSlope = int32(10171);
        DAQmx_Val_FieldDAQ = int32(16151);
        %*** Values for DAQmx_SwitchScan_RepeatMode ***
        %*** Value set SwitchScanRepeatMode ***
        DAQmx_Val_Finite = int32(10172);
        %*** Values for DAQmx_Dev_AI_SampModes ***
        %*** Values for DAQmx_Dev_AO_SampModes ***
        %*** Values for DAQmx_Dev_CI_SampModes ***
        %*** Values for DAQmx_Dev_CO_SampModes ***
        %*** Values for DAQmx_PhysicalChan_DI_SampModes ***
        %*** Values for DAQmx_PhysicalChan_DO_SampModes ***
        %*** Values for DAQmx_SampQuant_SampMode ***
        %*** Value set AcquisitionType ***
        DAQmx_Val_FiniteSamps = int32(10178);
        DAQmx_Val_FirstPretrigSamp = int32(10427);
        %*** Values for DAQmx_Read_RelativeTo ***
        %*** Value set ReadRelativeTo ***
        DAQmx_Val_FirstSample = int32(10424);
        DAQmx_Val_FirstSampleTimestamp = int32(16130);
        DAQmx_Val_Fixed50PercentDutyCycle = int32(14711);
        DAQmx_Val_FixedHighFreq = int32(14709);
        DAQmx_Val_FixedLowFreq = int32(14710);
        DAQmx_Val_FootPounds = int32(15884);
        DAQmx_Val_Force_Bridge = int32(15899);
        DAQmx_Val_Force_IEPESensor = int32(15895);
        DAQmx_Val_Freq = int32(10179);
        DAQmx_Val_Freq_Voltage = int32(10181);
        DAQmx_Val_FromCustomScale = int32(10065);
        DAQmx_Val_FromTEDS = int32(12516);
        %*** Values for DAQmx_AI_Bridge_Cfg ***
        %*** Value set BridgeConfiguration1 ***
        DAQmx_Val_FullBridge = int32(10182);
        %*** Values for DAQmx_AI_StrainGage_Cfg ***
        %*** Value set StrainGageBridgeType1 ***
        DAQmx_Val_FullBridgeI = int32(10183);
        DAQmx_Val_FullBridgeII = int32(10184);
        DAQmx_Val_FullBridgeIII = int32(10185);
        DAQmx_Val_FuncGen = int32(14750);
        DAQmx_Val_GND = int32(10066);
        DAQmx_Val_GPS_Timestamp = int32(10362);
        DAQmx_Val_Ground = int32(2);
        %*** Values for the Fill Mode parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16, DAQmxReadBinaryI32, DAQmxReadBinaryU32,
        %    DAQmxReadDigitalU8, DAQmxReadDigitalU32, DAQmxReadDigitalLines ***
        %*** Values for the Data Layout parameter of DAQmxWriteAnalogF64, DAQmxWriteBinaryI16, DAQmxWriteDigitalU8, DAQmxWriteDigitalU32, DAQmxWriteDigitalLines ***
        DAQmx_Val_GroupByChannel = int32(0);
        DAQmx_Val_GroupByScanNumber = int32(1);
        DAQmx_Val_HWTimedSinglePoint = int32(12522);
        DAQmx_Val_HalfBridge = int32(10187);
        DAQmx_Val_HalfBridgeI = int32(10188);
        DAQmx_Val_HalfBridgeII = int32(10189);
        %*** Values for DAQmx_SampClk_UnderflowBehavior ***
        %*** Values for DAQmx_Implicit_UnderflowBehavior ***
        %*** Value set UnderflowBehavior ***
        DAQmx_Val_HaltOutputAndError = int32(14615);
        DAQmx_Val_Handshake = int32(10389);
        %*** Values for DAQmx_Hshk_SampleInputDataWhen ***
        %*** Value set SampleInputDataWhen ***
        DAQmx_Val_HandshakeTriggerAsserts = int32(12552);
        DAQmx_Val_HandshakeTriggerDeasserts = int32(12553);
        DAQmx_Val_HardwareDefined = int32(10191);
        %*** Value set for the state parameter of DAQmxSetDigitalPowerUpStates ***
        DAQmx_Val_High = int32(10192);
        DAQmx_Val_HighFreq2Ctr = int32(10157);
        DAQmx_Val_HighImpedance = int32(12527);
        DAQmx_Val_HighResolution = int32(10195);
        DAQmx_Val_HighSpeed = int32(14712);
        DAQmx_Val_Highpass = int32(16072);
        %*** Values for DAQmx_SyncPulse_Time_Timescale ***
        %*** Values for DAQmx_FirstSampTimestamp_Timescale ***
        %*** Values for DAQmx_FirstSampClk_Timescale ***
        %*** Values for DAQmx_StartTrig_Timescale ***
        %*** Values for DAQmx_StartTrig_TimestampTimescale ***
        %*** Values for DAQmx_RefTrig_TimestampTimescale ***
        %*** Values for DAQmx_ArmStartTrig_Timescale ***
        %*** Values for DAQmx_ArmStartTrig_TimestampTimescale ***
        %*** Value set Timescale2 ***
        DAQmx_Val_HostTime = int32(16126);
        %*** Values for DAQmx_AI_Freq_Units ***
        %*** Value set FrequencyUnits ***
        DAQmx_Val_Hz = int32(10373);
        DAQmx_Val_IODeviceTime = int32(16127);
        %*** Values for DAQmx_CI_GPS_SyncMethod ***
        %*** Value set GpsSignalType1 ***
        DAQmx_Val_IRIGB = int32(10070);
        DAQmx_Val_IgnoreLostSyncLock = int32(16129);
        DAQmx_Val_IgnoreOverruns = int32(15863);
        %*** Values for DAQmx_Hshk_StartCond ***
        %*** Value set HandshakeStartCondition ***
        DAQmx_Val_Immediate = int32(10198);
        DAQmx_Val_Implicit = int32(10451);
        DAQmx_Val_InchOunces = int32(15882);
        DAQmx_Val_InchPounds = int32(15883);
        DAQmx_Val_Inches = int32(10379);
        DAQmx_Val_InchesPerSecond = int32(15960);
        DAQmx_Val_InchesPerSecondSquared = int32(12471);
        %*** Values for DAQmx_AnlgWin_PauseTrig_When ***
        %*** Value set WindowTriggerCondition2 ***
        DAQmx_Val_InsideWin = int32(10199);
        %*** Values for DAQmx_Exported_HshkEvent_OutputBehavior ***
        %*** Value set ExportActions5 ***
        DAQmx_Val_Interlocked = int32(12549);
        %*** Values for DAQmx_AI_CurrentShunt_Loc ***
        %*** Value set CurrentShuntResistorLocation1 ***
        DAQmx_Val_Internal = int32(10200);
        DAQmx_Val_Interrupts = int32(10204);
        DAQmx_Val_InvertPolarity = int32(1);
        %*** Values for DAQmx_AI_Thrmcpl_Type ***
        %*** Value set ThermocoupleType1 ***
        DAQmx_Val_J_Type_TC = int32(10072);
        DAQmx_Val_K_Type_TC = int32(10073);
        DAQmx_Val_Kelvins = int32(10325);
        DAQmx_Val_KilogramForce = int32(15877);
        DAQmx_Val_LargeRng2Ctr = int32(10205);
        DAQmx_Val_LeavingWin = int32(10208);
        DAQmx_Val_LeftJustified = int32(10209);
        %*** Values for DAQmx_Scale_Type ***
        %*** Value set ScaleType ***
        DAQmx_Val_Linear = int32(10447);
        DAQmx_Val_Load = int32(10440);
        %*** Values for DAQmx_AI_Excit_Sense ***
        %*** Values for DAQmx_Pwr_RemoteSense ***
        %*** Value set Sense ***
        DAQmx_Val_Local = int32(16095);
        DAQmx_Val_Log = int32(15844);
        DAQmx_Val_LogAndRead = int32(15842);
        %*** Values for DAQmx_CI_Freq_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Period_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_CountEdges_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_CountEdges_CountDir_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_CountEdges_CountReset_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_CountEdges_Gate_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_DutyCycle_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Encoder_AInputLogicLvlBehavior ***
        %*** Values for DAQmx_CI_Encoder_BInputLogicLvlBehavior ***
        %*** Values for DAQmx_CI_Encoder_ZInputLogicLvlBehavior ***
        %*** Values for DAQmx_CI_PulseWidth_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Velocity_Encoder_AInputLogicLvlBehavior ***
        %*** Values for DAQmx_CI_Velocity_Encoder_BInputLogicLvlBehavior ***
        %*** Values for DAQmx_CI_TwoEdgeSep_FirstLogicLvlBehavior ***
        %*** Values for DAQmx_CI_TwoEdgeSep_SecondLogicLvlBehavior ***
        %*** Values for DAQmx_CI_SemiPeriod_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Pulse_Freq_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Pulse_Time_LogicLvlBehavior ***
        %*** Values for DAQmx_CI_Pulse_Ticks_LogicLvlBehavior ***
        %*** Value set LogicLvlBehavior ***
        DAQmx_Val_LogicLevelPullUp = int32(16064);
        %*** Value set for the inputCalSource parameter of DAQmxAdjust1540Cal ***
        DAQmx_Val_Loopback0 = int32(0);
        DAQmx_Val_Loopback180 = int32(1);
        DAQmx_Val_LosslessPacking = int32(12555);
        DAQmx_Val_LossyLSBRemoval = int32(12556);
        DAQmx_Val_Low = int32(10214);
        %*** Values for DAQmx_CI_Freq_MeasMeth ***
        %*** Values for DAQmx_CI_Period_MeasMeth ***
        %*** Value set CounterFrequencyMethod ***
        DAQmx_Val_LowFreq1Ctr = int32(10105);
        %*** Values for DAQmx_AI_DigFltr_Type ***
        %*** Values for DAQmx_AI_DigFltr_Types ***
        %*** Value set FilterType2 ***
        DAQmx_Val_Lowpass = int32(16071);
        DAQmx_Val_Lvl = int32(10210);
        DAQmx_Val_MIODAQ = int32(16182);
        %*** Values for DAQmx_Dev_ProductCategory ***
        %*** Value set ProductCategory ***
        DAQmx_Val_MSeriesDAQ = int32(14643);
        DAQmx_Val_MaintainExistingValue = int32(12528);
        DAQmx_Val_MapRanges = int32(10448);
        DAQmx_Val_Master = int32(15888);
        DAQmx_Val_MaxShearStrain = int32(15977);
        DAQmx_Val_MaxShearStrainAngle = int32(15978);
        %*** Values for DAQmx_AI_LVDT_Units ***
        %*** Values for DAQmx_AI_EddyCurrentProxProbe_Units ***
        %*** Value set LengthUnits2 ***
        DAQmx_Val_Meters = int32(10219);
        DAQmx_Val_MetersPerSecond = int32(15959);
        DAQmx_Val_MetersPerSecondSquared = int32(12470);
        DAQmx_Val_MilliVoltsPerInchPerSecond = int32(15964);
        %*** Values for DAQmx_AI_Velocity_IEPESensor_SensitivityUnits ***
        %*** Value set VelocityIEPESensorSensitivityUnits ***
        DAQmx_Val_MillivoltsPerMillimeterPerSecond = int32(15963);
        DAQmx_Val_MostRecentSamp = int32(10428);
        DAQmx_Val_Multicycle = int32(14614);
        DAQmx_Val_NIELVIS = int32(14755);
        DAQmx_Val_NRSE = int32(10078);
        DAQmx_Val_N_Type_TC = int32(10077);
        DAQmx_Val_NetworkDAQ = int32(14829);
        DAQmx_Val_NewtonMeters = int32(15881);
        %*** Value set for Force IEPE functions ***
        DAQmx_Val_Newtons = int32(15875);
        %*** Values for DAQmx_SwitchScan_BreakMode ***
        %*** Value set BreakMode ***
        DAQmx_Val_NoAction = int32(10227);
        DAQmx_Val_NoBridge = int32(10228);
        DAQmx_Val_NoChange = int32(10160);
        %*** Values for DAQmx_AI_AutoZeroMode ***
        %*** Value set AutoZeroType1 ***
        DAQmx_Val_None = int32(10230);
        DAQmx_Val_Notch = int32(16074);
        %*** Values for DAQmx_Logging_Mode ***
        %*** Value set LoggingMode ***
        DAQmx_Val_Off = int32(10231);
        %*** Values for DAQmx_AI_Resistance_Units ***
        %*** Value set ResistanceUnits1 ***
        DAQmx_Val_Ohms = int32(10384);
        %*** Values for DAQmx_AO_DataXferReqCond ***
        %*** Values for DAQmx_DO_DataXferReqCond ***
        %*** Values for DAQmx_CO_DataXferReqCond ***
        %*** Value set OutputDataTransferCondition ***
        DAQmx_Val_OnBrdMemEmpty = int32(10235);
        DAQmx_Val_OnBrdMemHalfFullOrLess = int32(10239);
        %*** Values for DAQmx_AI_DataXferReqCond ***
        %*** Values for DAQmx_DI_DataXferReqCond ***
        %*** Values for DAQmx_CI_DataXferReqCond ***
        %*** Value set InputDataTransferCondition ***
        DAQmx_Val_OnBrdMemMoreThanHalfFull = int32(10237);
        DAQmx_Val_OnBrdMemNotEmpty = int32(10241);
        DAQmx_Val_OnBrdMemNotFull = int32(10242);
        DAQmx_Val_OnDemand = int32(10390);
        %*** Values for DAQmx_SyncPulse_Type ***
        %*** Value set SyncPulseType ***
        DAQmx_Val_Onboard = int32(16128);
        DAQmx_Val_OnbrdMemCustomThreshold = int32(12577);
        DAQmx_Val_OnbrdMemFull = int32(10236);
        %*** Values for DAQmx_Exported_RdyForXferEvent_DeassertCond ***
        %*** Value set DeassertCondition ***
        DAQmx_Val_OnbrdMemMoreThanHalfFull = int32(10237);
        DAQmx_Val_Once = int32(10244);
        %*** Value set RelayPos ***
        %*** Value set for the state parameter of DAQmxSwitchGetSingleRelayPos and DAQmxSwitchGetMultiRelayPos ***
        DAQmx_Val_Open = int32(10437);
        DAQmx_Val_OpenCollector = int32(12574);
        DAQmx_Val_OpenOrCreate = int32(15846);
        %*** Values for DAQmx_Pwr_IdleOutputBehavior ***
        %*** Value set PowerIdleOutputBehavior ***
        DAQmx_Val_OutputDisabled = int32(15503);
        DAQmx_Val_OutsideWin = int32(10251);
        DAQmx_Val_Overvoltage = int32(15502);
        %*** Values for DAQmx_Read_OverWrite ***
        %*** Value set OverwriteMode1 ***
        DAQmx_Val_OverwriteUnreadSamps = int32(10252);
        DAQmx_Val_PCCard = int32(12585);
        %*** Values for DAQmx_Dev_BusType ***
        %*** Value set BusType ***
        DAQmx_Val_PCI = int32(12582);
        DAQmx_Val_PCIe = int32(13612);
        DAQmx_Val_PPS = int32(10080);
        DAQmx_Val_PXI = int32(12583);
        DAQmx_Val_PXIe = int32(14706);
        DAQmx_Val_Pascals = int32(10081);
        DAQmx_Val_PathStatus_AlreadyExists = int32(10432);
        %*** Value set SwitchPathType ***
        %*** Value set for the output Path Status parameter of DAQmxSwitchFindPath ***
        DAQmx_Val_PathStatus_Available = int32(10431);
        DAQmx_Val_PathStatus_ChannelInUse = int32(10434);
        DAQmx_Val_PathStatus_ChannelReservedForRouting = int32(10436);
        DAQmx_Val_PathStatus_SourceChannelConflict = int32(10435);
        DAQmx_Val_PathStatus_Unsupported = int32(10433);
        DAQmx_Val_PatternDoesNotMatch = int32(10253);
        %*** Values for DAQmx_DigPattern_StartTrig_When ***
        %*** Values for DAQmx_DigPattern_RefTrig_When ***
        %*** Values for DAQmx_DigPattern_PauseTrig_When ***
        %*** Value set DigitalPatternCondition1 ***
        DAQmx_Val_PatternMatches = int32(10254);
        DAQmx_Val_PauseUntilDataAvailable = int32(14616);
        DAQmx_Val_Period = int32(10256);
        DAQmx_Val_PicoCoulombs = int32(16103);
        %*** Values for DAQmx_AI_Accel_Charge_SensitivityUnits ***
        %*** Value set AccelChargeSensitivityUnits ***
        DAQmx_Val_PicoCoulombsPerG = int32(16099);
        DAQmx_Val_PicoCoulombsPerInchesPerSecondSquared = int32(16101);
        DAQmx_Val_PicoCoulombsPerMetersPerSecondSquared = int32(16100);
        DAQmx_Val_PipelinedSampClk = int32(14668);
        DAQmx_Val_Poll = int32(12524);
        DAQmx_Val_Polynomial = int32(10449);
        DAQmx_Val_Position_AngEncoder = int32(10360);
        DAQmx_Val_Position_EddyCurrentProximityProbe = int32(14835);
        DAQmx_Val_Position_LVDT = int32(10352);
        DAQmx_Val_Position_LinEncoder = int32(10361);
        DAQmx_Val_Position_RVDT = int32(10353);
        DAQmx_Val_Pounds = int32(15876);
        DAQmx_Val_PoundsPerSquareInch = int32(15879);
        DAQmx_Val_Power = int32(16201);
        DAQmx_Val_PowerCalibrationType_Current = int32(15102);
        DAQmx_Val_PowerCalibrationType_LocalVoltage = int32(15101);
        %*** Value set for the calibration type for the 15200 Calibration functions ***
        DAQmx_Val_PowerCalibrationType_RemoteVoltage = int32(15100);
        DAQmx_Val_Pressure_Bridge = int32(15902);
        %*** Values for DAQmx_AI_RosetteStrainGage_RosetteMeasType ***
        %*** Value set StrainGageRosetteMeasurementType ***
        DAQmx_Val_PrincipalStrain1 = int32(15971);
        DAQmx_Val_PrincipalStrain2 = int32(15972);
        DAQmx_Val_PrincipalStrainAngle = int32(15973);
        DAQmx_Val_ProgrammedIO = int32(10264);
        DAQmx_Val_PseudoDiff = int32(12529);
        %*** Values for DAQmx_AI_RTD_Type ***
        %*** Value set RTDType1 ***
        DAQmx_Val_Pt3750 = int32(12481);
        DAQmx_Val_Pt3851 = int32(10071);
        DAQmx_Val_Pt3911 = int32(12482);
        DAQmx_Val_Pt3916 = int32(10069);
        DAQmx_Val_Pt3920 = int32(10053);
        DAQmx_Val_Pt3928 = int32(12483);
        DAQmx_Val_PullDown = int32(15951);
        %*** Value set for the state parameter of DAQmxSetDigitalPullUpPullDownStates ***
        DAQmx_Val_PullUp = int32(15950);
        %*** Values for DAQmx_Exported_CtrOutEvent_OutputBehavior ***
        %*** Value set ExportActions2 ***
        DAQmx_Val_Pulse = int32(10265);
        DAQmx_Val_PulseFrequency = int32(15864);
        DAQmx_Val_PulseTicks = int32(15866);
        DAQmx_Val_PulseTime = int32(15865);
        DAQmx_Val_PulseWidth = int32(10359);
        DAQmx_Val_Pulse_Freq = int32(10119);
        DAQmx_Val_Pulse_Ticks = int32(10268);
        %*** Values for DAQmx_CO_OutputType ***
        %*** Values for DAQmx_Dev_CO_SupportedOutputTypes ***
        %*** Values for DAQmx_PhysicalChan_CO_SupportedOutputTypes ***
        %*** Value set COOutputType ***
        DAQmx_Val_Pulse_Time = int32(10269);
        DAQmx_Val_QuarterBridge = int32(10270);
        DAQmx_Val_QuarterBridgeI = int32(10271);
        DAQmx_Val_QuarterBridgeII = int32(10272);
        %*** Value set ShuntElementLocation ***
        DAQmx_Val_R1 = int32(12465);
        DAQmx_Val_R2 = int32(12466);
        DAQmx_Val_R3 = int32(12467);
        DAQmx_Val_R4 = int32(14813);
        %*** Values for DAQmx_CI_Velocity_AngEncoder_Units ***
        %*** Value set AngularVelocityUnits ***
        DAQmx_Val_RPM = int32(16080);
        %*** Values for DAQmx_AI_TermCfg ***
        %*** Value set InputTermCfg ***
        DAQmx_Val_RSE = int32(10083);
        DAQmx_Val_R_Type_TC = int32(10082);
        DAQmx_Val_Radians = int32(10273);
        DAQmx_Val_RadiansPerSecond = int32(16081);
        %*** Values for DAQmx_AI_RosetteStrainGage_RosetteType ***
        %*** Value set StrainGageRosetteType ***
        DAQmx_Val_RectangularRosette = int32(15968);
        DAQmx_Val_RefTrig = int32(10426);
        DAQmx_Val_ReferenceTrigger = int32(12490);
        DAQmx_Val_Remote = int32(16096);
        %*** Values for DAQmx_CI_SampClkOverrunBehavior ***
        %*** Value set SampClkOverrunBehavior ***
        DAQmx_Val_RepeatedData = int32(16062);
        DAQmx_Val_ReservedForRouting = int32(10441);
        %*** Values for the Action parameter of DAQmxControlWatchdogTask ***
        DAQmx_Val_ResetTimer = int32(0);
        DAQmx_Val_Resistance = int32(10278);
        %*** Values for DAQmx_AI_RawSampJustification ***
        %*** Value set DataJustification1 ***
        DAQmx_Val_RightJustified = int32(10279);
        %*** Value set for the ActiveEdge parameter of DAQmxCfgSampClkTiming and DAQmxCfgPipelinedSampClkTiming ***
        DAQmx_Val_Rising = int32(10280);
        %*** Values for DAQmx_AnlgEdge_StartTrig_Slope ***
        %*** Values for DAQmx_AnlgMultiEdge_StartTrig_Slopes ***
        %*** Values for DAQmx_AnlgEdge_RefTrig_Slope ***
        %*** Values for DAQmx_AnlgMultiEdge_RefTrig_Slopes ***
        %*** Value set Slope1 ***
        DAQmx_Val_RisingSlope = int32(10280);
        DAQmx_Val_Rosette_Strain_Gage = int32(15980);
        DAQmx_Val_SCC = int32(14707);
        DAQmx_Val_SCCConnectorBlock = int32(14704);
        DAQmx_Val_SCCModule = int32(14705);
        DAQmx_Val_SCExpress = int32(15886);
        DAQmx_Val_SCSeriesDAQ = int32(14645);
        DAQmx_Val_SCXI = int32(12584);
        DAQmx_Val_SCXI1124Range0to10V = int32(14631);
        %*** Value set SCXI1124Range ***
        DAQmx_Val_SCXI1124Range0to1V = int32(14629);
        DAQmx_Val_SCXI1124Range0to20mA = int32(14635);
        DAQmx_Val_SCXI1124Range0to5V = int32(14630);
        DAQmx_Val_SCXI1124RangeNeg10to10V = int32(14634);
        DAQmx_Val_SCXI1124RangeNeg1to1V = int32(14632);
        DAQmx_Val_SCXI1124RangeNeg5to5V = int32(14633);
        DAQmx_Val_SCXIModule = int32(14660);
        DAQmx_Val_SSeriesDAQ = int32(14644);
        DAQmx_Val_S_Type_TC = int32(10085);
        DAQmx_Val_SameAsMasterTimebase = int32(10282);
        %*** Values for DAQmx_AIConv_Timebase_Src ***
        %*** Value set MIOAIConvertTbSrc ***
        DAQmx_Val_SameAsSampTimebase = int32(10284);
        %*** Values for DAQmx_SampTimingType ***
        %*** Value set SampleTimingType ***
        DAQmx_Val_SampClk = int32(10388);
        %*** Values for DAQmx_DI_AcquireOn ***
        %*** Values for DAQmx_DO_GenerateOn ***
        %*** Value set SampleClockActiveOrInactiveEdgeSelection ***
        DAQmx_Val_SampClkActiveEdge = int32(14617);
        DAQmx_Val_SampClkInactiveEdge = int32(14618);
        %*** Values for DAQmx_StartTrig_DelayUnits ***
        %*** Value set DigitalWidthUnits1 ***
        DAQmx_Val_SampClkPeriods = int32(10286);
        DAQmx_Val_SampleClkPeriods = int32(10286);
        DAQmx_Val_SampleClock = int32(12487);
        %*** Value set Signal2 ***
        DAQmx_Val_SampleCompleteEvent = int32(12530);
        DAQmx_Val_Save_AllowInteractiveDeletion = (bitshift(int32(1),2));
        DAQmx_Val_Save_AllowInteractiveEditing = (bitshift(int32(1),1));
        % Value set for the Options parameter of DAQmxSaveTask, DAQmxSaveGlobalChan and DAQmxSaveScale
        DAQmx_Val_Save_Overwrite = (bitshift(int32(1),0));
        DAQmx_Val_Sawtooth = int32(14754);
        DAQmx_Val_Seconds = int32(10364);
        DAQmx_Val_SemiPeriod = int32(10289);
        DAQmx_Val_SentinelValue = int32(16063);
        %*** Values for DAQmx_AO_FuncGen_Type ***
        %*** Value set FuncGenType ***
        DAQmx_Val_Sine = int32(14751);
        %*** Value set TimingResponseMode ***
        DAQmx_Val_SingleCycle = int32(14613);
        DAQmx_Val_Slave = int32(15889);
        DAQmx_Val_Sleep = int32(12547);
        DAQmx_Val_Software = int32(10292);
        DAQmx_Val_SoundPressure_Microphone = int32(10354);
        %*** Values for DAQmx_SwitchChan_Usage ***
        %*** Value set SwitchUsageTypes ***
        DAQmx_Val_Source = int32(10439);
        DAQmx_Val_Square = int32(14753);
        %*** Value set for DAQmxWaitForValidTimestamp ***
        DAQmx_Val_StartTrigger = int32(12491);
        %*** Values for DAQmx_SampClk_OverrunBehavior ***
        %*** Value set OverflowBehavior ***
        DAQmx_Val_StopTaskAndError = int32(15862);
        %*** Values for DAQmx_AI_Strain_Units ***
        %*** Value set StrainUnits1 ***
        DAQmx_Val_Strain = int32(10299);
        DAQmx_Val_Strain_Gage = int32(10300);
        DAQmx_Val_SwitchBlock = int32(15870);
        DAQmx_Val_Switches = int32(14650);
        %*** Values for the Options parameter of the event registration functions
        DAQmx_Val_SynchronousEventCallbacks = (bitshift(int32(1),0));
        DAQmx_Val_TCPIP = int32(14828);
        DAQmx_Val_TEDS_Sensor = int32(12531);
        DAQmx_Val_TIOSeries = int32(14661);
        DAQmx_Val_T_Type_TC = int32(10086);
        DAQmx_Val_Table = int32(10450);
        DAQmx_Val_Task_Abort = int32(6);
        DAQmx_Val_Task_Commit = int32(3);
        DAQmx_Val_Task_Reserve = int32(4);
        % For backwards compatibility, the DAQmx_ReadWaitMode has to be defined because this was the original spelling
        % that has been later on corrected.
        %*** Values for the Mode parameter of DAQmxTaskControl ***
        DAQmx_Val_Task_Start = int32(0);
        DAQmx_Val_Task_Stop = int32(1);
        DAQmx_Val_Task_Unreserve = int32(5);
        DAQmx_Val_Task_Verify = int32(2);
        DAQmx_Val_TeeRosette = int32(15970);
        DAQmx_Val_Temp_BuiltInSensor = int32(10311);
        DAQmx_Val_Temp_RTD = int32(10301);
        DAQmx_Val_Temp_TC = int32(10303);
        DAQmx_Val_Temp_Thrmstr = int32(10302);
        DAQmx_Val_TestScaleChassis = int32(16180);
        DAQmx_Val_TestScaleModule = int32(16181);
        DAQmx_Val_Ticks = int32(10304);
        DAQmx_Val_Time = int32(15996);
        DAQmx_Val_Toggle = int32(10307);
        DAQmx_Val_Torque_Bridge = int32(15905);
        DAQmx_Val_Transferred_From_Buffer = int32(2);
        DAQmx_Val_Triangle = int32(14752);
        DAQmx_Val_Tristate = int32(10310);
        DAQmx_Val_TwoEdgeSep = int32(10267);
        DAQmx_Val_TwoPointLinear = int32(15898);
        DAQmx_Val_TwoPulseCounting = int32(10313);
        DAQmx_Val_USB = int32(12586);
        DAQmx_Val_USBDAQ = int32(14646);
        DAQmx_Val_USBbulk = int32(12590);
        %*** Values for DAQmx_CO_ConstrainedGenMode ***
        %*** Value set ConstrainedGenMode ***
        DAQmx_Val_Unconstrained = int32(14708);
        DAQmx_Val_Unknown = int32(12588);
        DAQmx_Val_UserProvided = int32(10167);
        DAQmx_Val_Velocity_AngEncoder = int32(16078);
        DAQmx_Val_Velocity_IEPESensor = int32(15966);
        DAQmx_Val_Velocity_LinEncoder = int32(16079);
        %*** Value set for calibration mode for 4339 Calibration functions ***
        DAQmx_Val_Voltage = int32(10322);
        DAQmx_Val_VoltageRMS = int32(10350);
        DAQmx_Val_Voltage_CustomWithExcitation = int32(10323);
        %*** Values for DAQmx_Scale_PreScaledUnits ***
        %*** Value set UnitsPreScaled ***
        DAQmx_Val_Volts = int32(10348);
        DAQmx_Val_VoltsPerG = int32(12510);
        DAQmx_Val_VoltsPerMil = int32(14837);
        DAQmx_Val_VoltsPerMillimeter = int32(14839);
        %*** Values for DAQmx_AI_Bridge_ElectricalUnits ***
        %*** Value set BridgeElectricalUnits ***
        DAQmx_Val_VoltsPerVolt = int32(15896);
        DAQmx_Val_WDTExpiredEvent = int32(12512);
        DAQmx_Val_WaitForHandshakeTriggerAssert = int32(12550);
        DAQmx_Val_WaitForHandshakeTriggerDeassert = int32(12551);
        %*** Values for DAQmx_Read_WaitMode ***
        %*** Value set WaitMode ***
        DAQmx_Val_WaitForInterrupt = int32(12523);
        DAQmx_Val_WhenAcqComplete = int32(12546);
        %*** Value set WriteBasicTEDSOptions ***
        DAQmx_Val_WriteToEEPROM = int32(12538);
        DAQmx_Val_WriteToPROM = int32(12539);
        %*** Values for DAQmx_CI_Encoder_DecodingType ***
        %*** Values for DAQmx_CI_Velocity_Encoder_DecodingType ***
        %*** Value set EncoderType2 ***
        DAQmx_Val_X1 = int32(10090);
        DAQmx_Val_X2 = int32(10091);
        DAQmx_Val_X4 = int32(10092);
        DAQmx_Val_XSeriesDAQ = int32(15858);
        DAQmx_Val_Yield = int32(12525);
        %*** Values for DAQmx_AO_IdleOutputBehavior ***
        %*** Value set AOIdleOutputBehavior ***
        DAQmx_Val_ZeroVolts = int32(12526);
        %*** Values for DAQmx_AI_Excit_IdleOutputBehavior ***
        %*** Value set ExcitationIdleOutputBehavior ***
        DAQmx_Val_ZeroVoltsOrAmps = int32(12526);
        DAQmx_Val_g = int32(10186);
        %*** Values for DAQmx_AI_Accel_4WireDCVoltage_SensitivityUnits ***
        %*** Values for DAQmx_AI_Accel_SensitivityUnits ***
        %*** Value set AccelSensitivityUnits1 ***
        DAQmx_Val_mVoltsPerG = int32(12509);
        DAQmx_Val_mVoltsPerMicron = int32(14840);
        %*** Values for DAQmx_AI_EddyCurrentProxProbe_SensitivityUnits ***
        %*** Value set EddyCurrentProxProbeSensitivityUnits ***
        DAQmx_Val_mVoltsPerMil = int32(14836);
        DAQmx_Val_mVoltsPerMillimeter = int32(14838);
        %*** Values for DAQmx_AI_Force_IEPESensor_SensitivityUnits ***
        %*** Value set ForceIEPESensorSensitivityUnits ***
        DAQmx_Val_mVoltsPerNewton = int32(15891);
        DAQmx_Val_mVoltsPerPound = int32(15892);
        DAQmx_Val_mVoltsPerVolt = int32(15897);
        %*** Values for DAQmx_AI_RVDT_SensitivityUnits ***
        %*** Value set RVDTSensitivityUnits1 ***
        DAQmx_Val_mVoltsPerVoltPerDegree = int32(12507);
        DAQmx_Val_mVoltsPerVoltPerMilliInch = int32(12505);
        %*** Values for DAQmx_AI_LVDT_SensitivityUnits ***
        %*** Value set LVDTSensitivityUnits1 ***
        DAQmx_Val_mVoltsPerVoltPerMillimeter = int32(12506);
        DAQmx_Val_mVoltsPerVoltPerRadian = int32(12508);
        DAQmx_WatchdogExpirTrig_TrigOnNetworkConnLoss = hex2dec('305D');
        DAQmx_WatchdogExpirTrig_Type = hex2dec('21A3');
        DAQmx_Watchdog_AO_ExpirState = hex2dec('305F');
        DAQmx_Watchdog_AO_OutputType = hex2dec('305E');
        DAQmx_Watchdog_CO_ExpirState = hex2dec('3060');
        DAQmx_Watchdog_DO_ExpirState = hex2dec('21A7');
        DAQmx_Watchdog_HasExpired = hex2dec('21A8');
        %********** Watchdog Attributes **********
        DAQmx_Watchdog_Timeout = hex2dec('21A9');
        DAQmx_Write_AccessoryInsertionOrRemovalDetected = hex2dec('3053');
        DAQmx_Write_CurrWritePos = hex2dec('1458');
        DAQmx_Write_DevsWithInsertedOrRemovedAccessories = hex2dec('3054');
        DAQmx_Write_DigitalLines_BytesPerChan = hex2dec('217F');
        DAQmx_Write_ExternalOvervoltageChans = hex2dec('30BC');
        DAQmx_Write_ExternalOvervoltageChansExist = hex2dec('30BB');
        DAQmx_Write_NumChans = hex2dec('217E');
        DAQmx_Write_Offset = hex2dec('190D');
        DAQmx_Write_OpenCurrentLoopChans = hex2dec('29EB');
        DAQmx_Write_OpenCurrentLoopChansExist = hex2dec('29EA');
        DAQmx_Write_OvercurrentChans = hex2dec('29E9');
        DAQmx_Write_OvercurrentChansExist = hex2dec('29E8');
        DAQmx_Write_OverloadedChans = hex2dec('3085');
        DAQmx_Write_OverloadedChansExist = hex2dec('3084');
        DAQmx_Write_OvertemperatureChans = hex2dec('3083');
        DAQmx_Write_OvertemperatureChansExist = hex2dec('2A84');
        DAQmx_Write_PowerSupplyFaultChans = hex2dec('29ED');
        DAQmx_Write_PowerSupplyFaultChansExist = hex2dec('29EC');
        DAQmx_Write_RawDataWidth = hex2dec('217D');
        DAQmx_Write_RegenMode = hex2dec('1453');
        %********** Write Attributes **********
        DAQmx_Write_RelativeTo = hex2dec('190C');
        DAQmx_Write_SleepTime = hex2dec('22B2');
        DAQmx_Write_SpaceAvail = hex2dec('1460');
        DAQmx_Write_Sync_UnlockedChans = hex2dec('3140');
        DAQmx_Write_Sync_UnlockedChansExist = hex2dec('313F');
        DAQmx_Write_TotalSampPerChanGenerated = hex2dec('192B');
        DAQmx_Write_WaitMode = hex2dec('22B1');
    end
end
