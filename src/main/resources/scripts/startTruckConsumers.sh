#!/bin/bash

export JAVA_HOME=$(find /usr/jdk64 -iname 'jdk1.8*' -type d)
export PATH=$PATH:$JAVA_HOME/bin
export SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR=smm-producers-consumers-generator-jar-with-dependencies.jar


export kafkaBrokers="a-dps-connected-dp11.field.hortonworks.com:6667,a-dps-connected-dp12.field.hortonworks.com:6667,a-dps-connected-dp13.field.hortonworks.com:6667,a-dps-connected-dp14.field.hortonworks.com:6667,a-dps-connected-dp15.field.hortonworks.com:6667"
export schemaRegistryUrl=http://a-dps-connected-dp3.field.hortonworks.com:7788/api/v1
export securityProtocol=SASL_PLAINTEXT
export JAAS_CONFIG=" -Djava.security.auth.login.config=dev_consumer_jaas.conf "

export numOfEuropeTrucks=15


createStringConsumer() {
         java $JAAS_CONFIG -cp  \
                $SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR \
                hortonworks.hdf.smm.refapp.consumer.impl.LoggerStringEventConsumer \
                --bootstrap.servers $kafkaBrokers \
                --schema.registry.url $schemaRegistryUrl \
                --security.protocol $securityProtocol \
                --topics $1 \
                --groupId $2 \
                --clientId $3 \
                --auto.offset.reset latest >  "$4" &
}

createAvroConsumer() {
         java $JAAS_CONFIG -cp  \
                $SMM_PRODUCERS_CONSUMERS_SIMULATOR_JAR \
                hortonworks.hdf.smm.refapp.consumer.impl.LoggerAvroEventConsumer \
                --bootstrap.servers $kafkaBrokers \
                --schema.registry.url $schemaRegistryUrl \
                --security.protocol $securityProtocol \
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



createMicroServiceConsumers() {

	
	topics=(route-planning load-optimization fuel-logistics supply-chain predictive-alerts energy-mgmt audit-events compliance adjudication approval)
	services=(route load-optimizer fuel supply-chain predictive energy audit compliance adjudication approval)
	i=0
	for topic in "${topics[@]}"
	do
    	topicName=$topic
        groupId=${services[i]}-micro-service
        clientId=consumer-1;
        logFile=$groupId-$clientId.out;
        createStringConsumer $topicName $groupId $clientId $logFile
        i=$((i+1))
	done  	
	
}

createKafkaStreamsConsumerForTruckGeoAvro
createSparkStreamingConsumerForTruckGeoAvro;
createFlinkStreamingConsumerForTruckGeoAvro;
createMicroServiceConsumers;
