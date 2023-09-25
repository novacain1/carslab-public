#!/bin/bash -x

# For Red Hat OpenShift Platform, assumes FlexRAN l1 is running in a pod
export KUBECONFIG=~/kubeconfig-flexranicx

# copies files out of the running FlexRAN L1 pod to override default XML values
PODNAME=`oc get pods -n flexranl1 -o=jsonpath='{.items[*].metadata.name}'`
oc cp $PODNAME:/opt/flexran/bin/nr5g/gnb/l1/phycfg_timer.xml phycfg_timer.xml
oc cp $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac/testmac_cfg.xml testmac_cfg.xml
oc cp $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac/l2.sh l2.sh
oc cp $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac/traffic_profile/testmac_power.cfg testmac_power.cfg

#figure out the FEC accelerator device passed in the pod, as FlexRAN can't figure this out
FEC=`for i in $(oc get pod -n flexranl1 -o jsonpath='{.items[*].metadata.name}'); do oc exec ${i} -- bash -c 'printenv|grep PCIDEVICE_INTEL| grep FEC'; done`
FECDEV=`echo $FEC | awk -F '=' '{print $2}'`

l1_file=phycfg_timer.xml
systemthread=2
wlsnrtthread=2
timerThread=4
FpgaDriverCpuInfo=3
FrontHaulCpuInfo=3
radioDpdkMaster=4
sed -i "s#<wls_cell_mapping0>.*</wls_cell_mapping0>#<wls_cell_mapping0>0xFFF</wls_cell_mapping0>#g" $l1_file
sed -i "s#<wlsMacMemorySize>.*</wlsMacMemorySize>#<wlsMacMemorySize>0x7EA80000</wlsMacMemorySize>#g" $l1_file
sed -i "s#<wlsPhyMemorySize>.*</wlsPhyMemorySize>#<wlsPhyMemorySize>0x78000000</wlsPhyMemorySize>#g" $l1_file
sed -i "s#<dpdkMemorySize>.*</dpdkMemorySize>#<dpdkMemorySize>8144</dpdkMemorySize>#g" $l1_file
sed -i "s#<dpdkBasebandFecMode>.*</dpdkBasebandFecMode>#<dpdkBasebandFecMode>1</dpdkBasebandFecMode>#g" $l1_file
sed -i "s#<dpdkBasebandDevice>.*</dpdkBasebandDevice>#<dpdkBasebandDevice>$FECDEV</dpdkBasebandDevice>#g" $l1_file	
sed -i "s#<BeamWeightSrsBypass>.*</BeamWeightSrsBypass>#<BeamWeightSrsBypass>1</BeamWeightSrsBypass>#g" $l1_file
sed -i "s#<SrsAgcEnabled>.*</SrsAgcEnabled>#<SrsAgcEnabled>0</SrsAgcEnabled>#g" $l1_file
sed -i "s#<eBbuPoolPowerSavingsEnable>.*</eBbuPoolPowerSavingsEnable>#<eBbuPoolPowerSavingsEnable>1</eBbuPoolPowerSavingsEnable>#g" $l1_file	
sed -i "s#<eBbuPoolPowerSavingsMode>.*</eBbuPoolPowerSavingsMode>#<eBbuPoolPowerSavingsMode>2</eBbuPoolPowerSavingsMode>#g" $l1_file
sed -i "s#<eBbuPoolPowerCoreMask>.*</eBbuPoolPowerCoreMask>#<eBbuPoolPowerCoreMask>0x10000000100</eBbuPoolPowerCoreMask>#g" $l1_file

sed -i "s#<systemThread>.*</systemThread>#<systemThread>$systemthread, 0, 0<\/systemThread>#g" $l1_file
sed -i "s#<wlsNrtThread>.*, 0, 0</wlsNrtThread>#<wlsNrtThread>$wlsnrtthread, 0, 0</wlsNrtThread>#g" $l1_file
sed -i "s#<timerThread>.*</timerThread>#<timerThread>$timerThread, 96, 0</timerThread>#g" $l1_file
sed -i "s#<FpgaDriverCpuInfo>.*</FpgaDriverCpuInfo>#<FpgaDriverCpuInfo>$FpgaDriverCpuInfo, 96, 0</FpgaDriverCpuInfo>#g" $l1_file
sed -i "s#<FrontHaulCpuInfo>.*</FrontHaulCpuInfo>#<FrontHaulCpuInfo>$FrontHaulCpuInfo, 96, 0</FrontHaulCpuInfo>#g" $l1_file
sed -i "s#<radioDpdkMaster>.*</radioDpdkMaster>#<radioDpdkMaster>$radioDpdkMaster, 99, 0</radioDpdkMaster>#g" $l1_file

testmaccfg_file=testmac_cfg.xml
wlsrxthread=3
systemthread=2
runThread=3
sed -i "s#<wlsRxThread>.*</wlsRxThread>#<wlsRxThread>$wlsrxthread, 90, 0</wlsRxThread>#g" $testmaccfg_file
sed -i "s#<systemThread>.*</systemThread>#<systemThread>$systemthread, 0, 0</systemThread>#g" $testmaccfg_file
sed -i "s#<runThread>.*</runThread>#<runThread>$runThread, 89, 0</runThread>#g" $testmaccfg_file
sed -i "s#<ConfigFromTestFile>.*</ConfigFromTestFile>#<ConfigFromTestFile>1</ConfigFromTestFile>#g" $testmaccfg_file

l2_file=l2.sh
cpulist=2-17,34-49
sed -i "s/^\\(cpuListString=\\).*/\\1$cpulist/" $l2_file
chmod +x $l2_file

test_file=testmac_power.cfg
setsrscore=0xC0000000C0
setcore=0x3ffC00003ffC0 #working with 32c
#setcore=0x3FE000003FE0 #24c not working
sed -i "s#setsrscore .*#setsrscore $setsrscore#g" $test_file
sed -i "s#setcore .*#setcore $setcore#g" $test_file

# copies files to the running FlexRAN L1 pod to override default XML values
PODNAME=`oc get pods -n flexranl1 -o=jsonpath='{.items[*].metadata.name}'`
oc cp phycfg_timer.xml $PODNAME:/opt/flexran/bin/nr5g/gnb/l1
oc cp testmac_cfg.xml $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac
oc cp l2.sh $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac
oc cp testmac_power.cfg $PODNAME:/opt/flexran/bin/nr5g/gnb/testmac/traffic_profile
