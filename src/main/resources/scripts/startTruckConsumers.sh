#!/bin/bash

export JAVA_HOME=$(find /usr/jdk64 -iname 'jdk1.8*' -type d)
export PATH=$PATH:$JAVA_HOME/bin
export numOfEuropeTrucks=15
export kafkaBrokers="a-summit11.field.hortonworks.com:6667,a-summit12.field.hortonworks.com:6667,a-summit13.field.hortonworks.com:6667,a-summit14.field.hortonworks.com:6667,a-summit15.field.hortonworks.com:6667"
export schemaRegistryUrl=http://a-summit3.field.hortonworks.com:7788/api/v1

createConsumersForTruckGeoAvro() {
	
	topicName="syndicate-geo-event-avro";
	groupId = "kstreams-analytics-geo-event";
	clientId = "consumer-1";
	logFile = "kstreams-analytics-geo-event.out";
	createStringConsumer $topicName $groupdId $clientId $logFile

}

createStringConumer() {

	nohup java -cp \
		smm-ref-app-jar-with-dependencies.jar \
		hortonworks.hdf.smm.refapp.consumer.impl.LoggerStringEventConsumer \
		$kafkaBrokers \
		$schemaRegistryUrl \
		$1,
		$2,
		$3,
		latest > $4 &
}

createConsumersForTruckGeoAvro;
