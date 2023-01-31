#!/usr/local/bin/bash
#
rm /scripts/log
DATE=$(date +%Y-%m-%d-%H%M%S)
echo "$DATE" >> /scripts/log
#
STATICSPEEDBASE16="0x0f"
TEMPTHRESHOLD="45"
#
T0=$(sysctl dev.cpu.0.temperature | cut -d" " -f2 | cut -d"." -f1)
T1=$(sysctl dev.cpu.1.temperature | cut -d" " -f2 | cut -d"." -f1)
T2=$(sysctl dev.cpu.2.temperature | cut -d" " -f2 | cut -d"." -f1)
T3=$(sysctl dev.cpu.3.temperature | cut -d" " -f2 | cut -d"." -f1)
echo "-- current temperatures --" >> /scripts/log
echo "CPU0: $T0" >> /scripts/log
echo "CPU1: $T1" >> /scripts/log
echo "CPU2: $T2" >> /scripts/log
echo "CPU3: $T3" >> /scripts/log
echo "Temp threshold is $TEMPTHRESHOLD" >> /scripts/log
#
if [[ $T0 > $TEMPTHRESHOLD || $T1 > $TEMPTHRESHOLD || $T2 > $TEMPTHRESHOLD || $T3 > $TEMPTHRESHOLD ]];
then
echo "--> enable dynamic fan control" >> /scripts/log
ipmitool raw 0x30 0x30 0x01 0x01
else
echo "--> disable dynamic fan control" >> /scripts/log
ipmitool raw 0x30 0x30 0x01 0x00
echo "--> set static fan speed to 15 percent" >> /scripts/log
ipmitool raw 0x30 0x30 0x02 0xff $STATICSPEEDBASE16
fi
