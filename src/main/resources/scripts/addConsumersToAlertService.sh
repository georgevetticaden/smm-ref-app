#!/bin/bash

export JAVA_HOME=$(find /usr/jdk64 -iname 'jdk1.8*' -type d)
export PATH=$PATH:$JAVA_HOME/bin
export numOfEuropeTrucks=15
export kafkaBrokers="a-summit11.field.hortonworks.com:6667,a-summit12.field.hortonworks.com:6667,a-summit13.field.hortonworks.com:6667,a-summit14.field.hortonworks.com:6667,a-summit15.field.hortonworks.com:6667"
export schemaRegistryUrl=http://a-summit3.field.hortonworks.com:7788/api/v1

createStringConsumer() {
         java -cp \
                ../../smm-producers-consumers-generator-jar-with-dependencies.jar \
                hortonworks.hdf.smm.refapp.consumer.impl.LoggerStringEventConsumer \
                --bootstrap.servers $kafkaBrokers \
                --schema.registry.url $schemaRegistryUrl \
                --topics $1 \
                --groupId $2 \
                --clientId $3 \
                --auto.offset.reset latest >  "$4" &
}

createCriticalAlertMicroConsumerService() {
        topicName="syndicate-all-geo-critical-events";
        groupId="micro-alert-service";
        clientId=$1;
        logFile="micro-alert-service.out";
        createStringConsumer $topicName $groupId $clientId $logFile

};

addConsumerGroups() {
	createCriticalAlertMicroConsumerService "consumer-2";
	createCriticalAlertMicroConsumerService "consumer-3";
	createCriticalAlertMicroConsumerService "consumer-4";
	createCriticalAlertMicroConsumerService "consumer-5";
}

addConsumerGroups;
