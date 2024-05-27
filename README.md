# OpenSource

# LightSwitch 오픈소스

LightSwitch는 오픈소스 피쳐플래깅 솔루션으로, 가볍고 편리하게 A/B Test, Target Test를 지원합니다. 또한, Docker Image 형태로 배포되어 편리하게 서비스와 통합 가능하며, 현재 Java, JavaScript, Python 언어를 지원합니다.

## 특징

- 5555(Nginx) 포트를 사용합니다.
- 사용하시는 환경에서 해당 포트와 충돌나지 않도록 주의해주세요.
- 컨테이너를 실행시킬 때 내부의 Nginx가 5555번 포트를 listen하고 있으므로, 5555번 포트로 열어주세요.

- 해당 오픈소스는 SSR이 아닌 CSR이므로 Front <-> Back으로 api 요청을 보냅니다.
- 따라서, CORS설정을 위해 사용하시는 환경의 ip:port를 DOMAIN이라는 환경변수 이름으로 넣어주시기 바랍니다.
- 예) -e DOMAIN=http://lightswitch.kr:5555

### 사용 예시
// 최신 버전 docker image pull
```
$ docker pull lightswitch2024/lightswitch:latest
```

Case 1 (SSL적용 X)
// 컨테이너 실행
// run 실행 시 frontend, backend build가 이루어지므로 약간의 시간이 소요됩니다.
```
$ docker run -d -p 5555:5555 -e domain=http://lightswitch.kr:5555 lightswitch2024/lightswitch:latest
```
- ip:5555 주소로 접속한다면 lightswitch의 로그인 창이 뜨고, 회원가입을 진행한 후 이용하실 수 있습니다.
- 플래그에 관한 기능은 lightswitch.kr에서 제공하는 기능과 동일합니다.
- 오픈소스와 sdk를 연결하고자 한다면, endpoint를 기존의 lightswitch.kr에서 ip:5555로 변경하시면 됩니다.




Case 2 (SSL적용 O)
```
$ docker run -d -p 5555:5555 -e domain=https://lightswitch.kr -e prefix=/lightswitch lightswitch2024/lightswitch:latest
```

- 사용하시는 Nginx에서 SSL이 적용되어 있다면, domain은 다음과 같이 포트 번호를 지워주시기 바랍니다.
- 또한, Nginx에서 Reverse Proxy하려는 Path(예시에서는 /lightswitch)를 prefix에 넣어주시기 바랍니다.
- 또한 아래와 같은 Nginx 설정이 필요합니다.

```
location /lightswitch {
	proxy_pass {your_ip}:5555
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header X-Forwarded-Proto $scheme;
	
	# SSE를 위한 설정
	proxy_buffering off;
	proxy_cache_bypass $http_upgrade;
	proxy_http_version 1.1;
	proxy_set_header Connection "";
}
```


- 또한, 추가적인 CORS 설정이 필요한 경우
- 해당 path로 domains라는 이름으로 원하시는 CORS 설정 주소를 추가하여
- POST요청을 보내시면 추가적인 CORS설정이 완료됩니다.

```
path: {your_endpoint}/api/v1/domain/cors
method: POST
{
	"domains":[
		"http://localhost:3000",
		...
	]
}
```
