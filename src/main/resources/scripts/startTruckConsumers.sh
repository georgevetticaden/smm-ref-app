#!/bin/bash

export JAVA_HOME=$(find /usr/jdk64 -iname 'jdk1.8*' -type d)
export PATH=$PATH:$JAVA_HOME/bin
export numOfEuropeTrucks=15
export kafkaBrokers="a-summit11.field.hortonworks.com:6667,a-summit12.field.hortonworks.com:6667,a-summit13.field.hortonworks.com:6667,a-summit14.field.hortonworks.com:6667,a-summit15.field.hortonworks.com:6667"
export schemaRegistryUrl=http://a-summit3.field.hortonworks.com:7788/api/v1
export SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR=smm-producers-consumers-generator-jar-with-dependencies.jar

createStringConsumer() {
         java -cp \
                $SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR \
                hortonworks.hdf.smm.refapp.consumer.impl.LoggerStringEventConsumer \
                --bootstrap.servers $kafkaBrokers \
                --schema.registry.url $schemaRegistryUrl \
                --topics $1 \
                --groupId $2 \
                --clientId $3 \
                --auto.offset.reset latest >  "$4" &
}

createAvroConsumer() {
         java -cp \
                $SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR \
                hortonworks.hdf.smm.refapp.consumer.impl.LoggerAvroEventConsumer \
                --bootstrap.servers $kafkaBrokers \
                --schema.registry.url $schemaRegistryUrl \
                --topics $1 \
                --groupId $2 \
                --clientId $3 \
                --auto.offset.reset latest >  "$4" &
}

createKafkaStreamsConsumerForTruckGeoAvro() {
        topicName="syndicate-geo-event-avro";
        groupId="kafka-streams-analytics-geo-event";
        clientId="consumer-1";
        logFile="kafka-streams-analytics-geo-event.out";
        createAvroConsumer $topicName $groupId $clientId $logFile

}

createSparkStreamingConsumerForTruckGeoAvro() {
        topicName="syndicate-geo-event-avro";
        groupId="spark-streaming-analytics-geo-event";
        clientId="consumer-1";
        logFile="spark-streaming-analytics-geo-event.out";
        createAvroConsumer $topicName $groupId $clientId $logFile

}

createFlinkStreamingConsumerForTruckGeoAvro() {
        topicName="syndicate-geo-event-avro";
        groupId="flink-analytics-geo-event";
        clientId="consumer-1";
        logFile="flink-analytics-geo-event.out";
        createAvroConsumer $topicName $groupId $clientId $logFile

}

createKafkaStreamsConsumerForTruckGeoAvro
createSparkStreamingConsumerForTruckGeoAvro;
createFlinkStreamingConsumerForTruckGeoAvro;
