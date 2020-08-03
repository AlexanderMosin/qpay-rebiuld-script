#Change parameters
set sid=mav
set db=dpdb-spb.ftc.ru:1529
set redisHost=sobrat.ftc.ru
set redisPort=6379

unzip *.war -d ./online-service

cd ./online-service/WEB-INF/classes


sed -i -r "s#(datasource.oracle.url=jdbc:tracing:oracle:thin:@).*#\1%db%:%sid%?traceWithActiveSpanOnly=true#" service.properties
sed -i -r "s#(datasource.events.url=jdbc:tracing:oracle:thin:@).*#\1%db%:%sid%?traceWithActiveSpanOnly=true#" service.properties

sed -i -r "s#(ips.url=).*#\1https://localhost:58888#" service.properties
sed -i -r "s#(cache.areas.expireAfter=).*#\11s#" service.properties
sed -i -r "s#(onlineid.url=).*#\1http://localhost:61111#" service.properties
sed -i -r "s#(ais.url=).*#\1http://localhost:63333#" service.properties
sed -i -r "s#(rabbitmq.virtualHost=).*#\1stub#" service.properties
sed -i -r "s#(rabbitmq.username=).*#\1stub#" service.properties
sed -i -r "s#(rabbitmq.password=).*#\1stub#" service.properties
sed -i -r "s#(jaeger.sampler.value=).*#\10.0#" service.properties
sed -i -r "s#(redis.host=).*#\1%redisHost%#" service.properties
sed -i -r "s#(redis.port=).*#\1%redisPort%#" service.properties
sed -i -r "s#(redis.password=).*#\1b62c5d20-b746-4ce6-b01e-690641e4702f#" service.properties

sed -i -r "s#(ips.collectDataPageUrl=).*#\1http://localhost:8080/online-service/payments/collect-data-pages#" service.properties
sed -i -r "s#(ips.threeDSAuthPageUrl=).*#\1http://localhost:8080/online-service/payments/authentication-page#" service.properties
sed -i -r "s#(ips.threeDS1AuthCompletionUrl=).*#\1http://localhost:8080/online-service/payments/3ds1/authentications#" service.properties
sed -i -r "s#(ips.threeDS2AuthCompletionUrl=).*#\1http://localhost:8080/online-service/payments/3ds2/authentications#" service.properties
sed -i -r "s#(cleandossier.validationEnabled=).*#\1true#" service.properties
sed -i -r "s#(cleandossier.url=).*#\1http://localhost:51111#" service.properties
sed -i -r "s#(jms.filterMessagesByDestination=).*#\1false#" service.properties

sed -i -r "s#(ips.collectDataPageUrl=).*#\1http://localhost:8080/online-service/payments/collect-data-page#" service.properties

sed -i -r 's!"baseUrl".*!"baseUrl": "http://localhost:64444",!' acquirer.json
sed -i -r "s#online_blr#blr#" acquirer.json

cd ../../..
cp key ./online-service/WEB-INF/classes/keys/clientcert.jks
cp key ./online-service/WEB-INF/classes/keys/sitestore.jks
cp kzt.jks ./online-service/WEB-INF/classes/keys/kzt.jks
cp kzt.jks ./online-service/WEB-INF/classes/keys/blr.jks


cd online-service
zip -r ../online-service.war ./*

cd ..
rm -r online-service