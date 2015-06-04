#!/bin/sh

#echo -e 'HTTP/1.2 200 OK\r\nContent-type: text/plain\r\n\r\n'
echo -e 'Content-type: text/plain\r\n\r\n'

#echo $*
CONF_FILE="/tmp/tc.sh__connection.conf"
SETTEMP_FILE="/tmp/tc.sh__settemp.conf"
POWER_STATE=""

COMMAND=`echo $1 | cut -f1 -d'?' | cut -f1 -d'\'`
VALUE=`echo $1 | cut -f2 -d'&' | cut -f1 -d'\'`
DEBUG=`echo $1 | cut -f3 -d'&'`

if [ X$DEBUG = "Xdebug" ]; then
	DEBUG=1
	echo "COMMAND=\"${COMMAND}\""
	echo VALUE=$VALUE
else
	DEBUG=0
fi

#echo "OK"
# Second(int second, int minute, int hour, int day, int month, int year)
#TIMESTAMP=`date +%H:%M:%S`
MONTH=`date +%m`
MONTH=`expr $MONTH - 1`
TIMESTAMP=`date +%Y:${MONTH}:%d:%H:%M:%S`

DATE=`date +%S`

if [ $DATE -gt 40 ]; then
	TEMP=0
	#TEMP=`expr $DATE % 21`
else
	TEMP=`expr $DATE - 20`;
fi


#   -------------------------------------------------- STATUS -------------------------------------------------
#       1            1             1              1             1             1              1            1
#   ERROR_MODE    FAN1_ON       FAN0_ON     BLOCK0_2FANS    DUAL_MODE      BLOCK1_ON      BLOCK0_ON    POWER_ON
#       0            0             0              0             0             0              0            0
#   NORMAL_MODE   FAN1_OFF      FAN0_OFF    SEPARATE_FANS   SINGLE_MODE    BLOCK1_OFF     BLOCK0_OFF   POWER_OFF
#
# 34 = 00110101 POWER_OFF
# 35 = 00110101 POWER_ON
#
STATUS=19
TEMP0=$TEMP
TEMP1=$TEMP
TEMP2=$TEMP
TEMP3=`expr $TEMP + 20`
SETTEMP0=0
SETTEMP1=100
PWM0=50.0
PWM1=80.0
FAN0=3500
FAN1=3500
CONNECTION="OFF"
MESSAGE="OK"

if [ $DATE -gt 20 ]; then
	DIFF=`expr $DATE \* 10`;
	FAN0=`expr $FAN0 - $DIFF`;
fi

function get_connection()
{
	if [ -f $CONF_FILE ]; then
		CONNECTION=`cat $CONF_FILE | grep "CONNECTION"`;
		CONNECTION=`echo $CONNECTION | cut -f2 -d'='`
	else
		if [ $DEBUG -eq 1 ]; then
			echo "$0.get_connection(): $CONF_FILE not found"
		fi
		CONNECTION="OFF"
	fi

	if [ $DEBUG -eq 1 ]; then
		echo "$0.get_connection(): CONNECTION=$CONNECTION"
	fi
}

function connect()
{

	RAND=`echo $RANDOM`
	CON=`expr $RAND % 2`
	if [ $CON == 1 ]; then
		CONNECTED="U"
	else
		CONNECTED="B"
	fi

	if [ ! -f $CONF_FILE ]; then
		if [ $DEBUG -eq 1 ]; then
			echo "$0.connect(): $CONF_FILE not found - creating"
		fi
		RAND=`echo $RANDOM`
		CON=`expr $RAND % 2`
		echo "POWER_STATE=${POWER_STATE}" > $CONF_FILE
		echo "CONNECTION=${CONNECTED}" >> $CONF_FILE
	else
		CONNECTION=`cat $CONF_FILE | grep "CONNECTION"`;
		CONNECTION=`echo $CONNECTION | cut -f2 -d'='`
		if [ X$CONNECTION = "XOFF" ]; then
			cp ${CONF_FILE} ${CONF_FILE}.tmp
			sed -e s/CONNECTION=.*/CONNECTION=${CONNECTED}/ ${CONF_FILE}.tmp > ${CONF_FILE}
			rm ${CONF_FILE}.tmp
		fi
			
	fi
	get_connection
}

function get_power()
{
	if [ -f $CONF_FILE ]; then
		POWER=`cat $CONF_FILE | grep POWER_STATE`;
		POWER=`echo $POWER | cut -f2 -d'='`
		if [ $DEBUG -eq 1 ]; then
			echo "$0.get_power(): POWER_STATE=${POWER}"
		fi
	else
		if [ $DEBUG -eq 1 ]; then
			echo "$0.get_power(): $CONF_FILE not found"
		fi
		POWER="OFF"
	fi
	if [ X$POWER = "XOFF" ]; then
		PWM0=0
		PWM1=0
		FAN0=0
		FAN1=0
		POWER_STATE="OFF"
		STATUS=34
	else
		#PWM0=50
		POWER_STATE="ON"
		STATUS=35
	fi
}

function power()
{
	POWER_SWITCH=$1
	if [ -f ${CONF_FILE} ]; then
		cp ${CONF_FILE} ${CONF_FILE}.tmp
		sed -e s/POWER_STATE=.*/POWER_STATE=${POWER_SWITCH}/ ${CONF_FILE}.tmp > ${CONF_FILE}
		rm ${CONF_FILE}.tmp
	else
		if [ $DEBUG -eq 1 ]; then
			echo "$0.get_power(): ${CONF_FILE} not found"
		fi
		echo "POWER_STATE=${POWER_SWITCH}" > ${CONF_FILE}
		echo "CONNECTION=OFF" >> $CONF_FILE
	fi
	POWER_STATE="${POWER_SWITCH}"
	if [ $DEBUG -eq 1 ]; then
		echo "$0.power(): POWER=$POWER"
	fi
	get_power
}

function create_settemp()
{
	echo "SETTEMP0=0" > ${SETTEMP_FILE}
	echo "SETTEMP1=0" >> ${SETTEMP_FILE}
}

function get_settemp()
{
	SETTEMP0=0
	SETTEMP0=100
	if [ -f ${SETTEMP_FILE} ]; then
		SETTEMP0=`grep SETTEMP0 ${SETTEMP_FILE} | cut -f 2 -d'='`
		SETTEMP1=`grep SETTEMP1 ${SETTEMP_FILE} | cut -f 2 -d'='`
		if [ X$SETTEMP0 = "X" ]; then
			create_settemp
		fi
		if [ X$SETTEMP1 = "X" ]; then
			create_settemp
		fi
	else
		if [ $DEBUG -eq 1 ]; then
			echo "$0.get_settemp(): ${SETTEMP_FILE} not found"
		fi
		create_settemp
	fi
}

function set_settemp()
{
	SETTEMP0=$1
	SETTEMP1=$2
	echo "SETTEMP0=$SETTEMP0" > ${SETTEMP_FILE}
	echo "SETTEMP1=$SETTEMP1" >> ${SETTEMP_FILE}
}

# timestamp|status|temp0|temp1|temp2 |temp3 |pwm0|pwm1|fan0|fan1|message

if [ X$COMMAND = "XgetInfo" ]; then
	get_power
	get_connection
	get_settemp
	MESSAGE="OK"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" >> /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
elif [ X$COMMAND = "XgetSerial" ]; then
	echo "Serial : 12345678"
elif [ X$COMMAND = "Xrefresh" ]; then
	for i in `cat /tmp/tempctl.log`; do
		TIMESTAMP=`echo $i | cut -f2 -d'|'`
		TEMP0=`echo $i | cut -f4 -d'|'`
		TEMP3=`echo $i | cut -f7 -d'|'`
		echo "$TIMESTAMP|$TEMP0|$TEMP3"
	done	
elif [ X$COMMAND = "XsetDate" ]; then
	get_power
	get_settemp
	echo "SUCCESS! $0.set_date()|SUCCESS!\n\nTime set OK|INFORMATION_MESSAGE"
elif [ X$COMMAND = "XsetTemp0" ]; then
	get_power
	get_connection
	get_settemp
	set_settemp $VALUE $SETTEMP1
	MESSAGE="setTemp0"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" >> /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
elif [ X$COMMAND = "XsetTemp1" ]; then
	get_power
	get_connection
	get_settemp
	set_settemp $SETTEMP0 $VALUE
	MESSAGE="setTemp1"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" >> /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
elif [ X$COMMAND = "XpowerOff" ]; then
	#if [ -f $CONF_FILE ]; then
	#	rm -f $CONF_FILE
	#fi
	#if [ -f $SETTEMP_FILE ]; then
	#	rm -f $SETTEMP_FILE
	#fi
	#get_power
	power "OFF"
	get_connection
	get_settemp
	MESSAGE="powerOff"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" >> /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
elif [ X$COMMAND = "XpowerOn" ]; then
	power "ON"
	connect
	get_settemp
	MESSAGE="powerOn"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" > /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
elif [ X$COMMAND = "Xconnect" ]; then
	#tail -1 /tmp/tempctl.log
	get_power
	connect
	get_settemp
	MESSAGE="OK"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}"
elif [ X$COMMAND = "Xping" ]; then
	get_power
	get_connection
	echo "PING_OK"
else
	get_power
	get_connection
	get_settemp
	MESSAGE="FAIL"
	echo "${CONNECTION}|${TIMESTAMP}|${STATUS}|${TEMP0}|${TEMP1}|${TEMP2}|${TEMP3}|${SETTEMP0}|${SETTEMP1}|${PWM0}|${PWM1}|${FAN0}|${FAN1}|${MESSAGE}" >> /tmp/tempctl.log
	echo "`tail -1 /tmp/tempctl.log`"
fi

#echo "END"

