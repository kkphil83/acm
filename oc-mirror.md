
대화를 열었습니다. 읽은 메일이 1개 있습니다.

콘텐츠로 건너뛰기
스크린 리더로 Red Hat 메일 사용하기

7,810개 중 2개
oc-mirror 미러링 스크립트
받은편지함

Yesol Lee
첨부파일
오후 2:30 (2시간 전)
나에게

안녕하세요, 이예솔입니다.

oc-mirror 미러링 스크립트 전달드립니다.
추가로 필요하신거 있으시면 얼마든지 말씀해주세요!

감사합니다.

이예솔 드림
--
Yesol Lee

Associate Solution Architect

Red Hat

ASEM Tower 24F

517, Yeongdong-daero, Gangnam-Gu, 06164, Seoul, Korea

yeslee@redhat.com   
M: +82-10-6418-3934    


 첨부파일 2개
  •  Gmail에서 스캔함
# Disconnected Mirroring

# 1. oc-mirror OpenShift CLI plugin 설치

1.  oc-mirror CLI plugin 다운로드
    - [https://console.redhat.com/openshift/downloads](https://console.redhat.com/openshift/downloads)
2. tar 해제
    
    ```
    $ tar xvzf oc-mirror.tar.gz
    ```
    
3. 실행 권한 부여
    
    ```
    $ chmod +x oc-mirror
    ```
    
4.  `/usr/local/bin` 위치로 실행 파일 옮기기
    
    ```
    $ sudo mv oc-mirror /usr/local/bin/.
    ```
    

*확인*

- `oc mirror help` 명령어를 실행하여 plugin 설치 확인
    
    ```
    $ oc mirror help
    ```
    

# 2. pull-secret 생성

1. `registry.redhat.io` [](https://console.redhat.com/openshift/install/pull-secret)에서 pull secret 다운로드
2. pull secret 파일 복사 및 jq 명령어를 통해 편집하기 쉽게 형식 변경
    
    ```
    $ cat ./pull-secret | jq . > <path>/<pull_secret_file_in_json>
    ```
    
    ```
    {
      "auths": {
        "cloud.openshift.com": {
          "auth": "b3BlbnNo...",
          "email": "you@example.com"
        },
        "quay.io": {
          "auth": "b3BlbnNo...",
          "email": "you@example.com"
        },
        "registry.connect.redhat.com": {
          "auth": "NTE3Njg5Nj...",
          "email": "you@example.com"
        },
        "registry.redhat.io": {
          "auth": "NTE3Njg5Nj...",
          "email": "you@example.com"
        }
      }
    }
    ```
    
3. 사용자 이름과 비밀번호 또는 토큰을 base64로 인코딩
    
    ```
    $ echo-n '<user_name>:<password>' | base64-w0BGVtbYk3ZHAtqXs=
    ```
    
4. 인코딩한 결과값을 pull secret 파일에 추가합니다.
    
    ```
      "auths": {
        "<mirror_registry>": {
          "auth": "<credentials>",
          "email": "you@example.com"
        }
      },
    ```
    
    ```
    {
      "auths": {
        "registry.example.com": {
          "auth": "BGVtbYk3ZHAtqXs=",
          "email": "you@example.com"
        },
        "cloud.openshift.com": {
          "auth": "b3BlbnNo...",
          "email": "you@example.com"
        },
        "quay.io": {
          "auth": "b3BlbnNo...",
          "email": "you@example.com"
        },
        "registry.connect.redhat.com": {
          "auth": "NTE3Njg5Nj...",
          "email": "you@example.com"
        },
        "registry.redhat.io": {
          "auth": "NTE3Njg5Nj...",
          "email": "you@example.com"
        }
      }
    }
    ```
    

# 3. image-set 생성

1. `oc mirror init` 명령어를 통해 image set 설정의 템플릿을 생성하고 `imageset-config.yaml` 파일로 저장
    
    ```
    $ oc mirror init--registry example.com/mirror/oc-mirror-metadata > imageset-config.yaml
    ```
    
2. image set config 파일 편집
    
    ```jsx
    kind: ImageSetConfiguration
    apiVersion: mirror.openshift.io/v1alpha2
    archiveSize: 4            ##각 이미지 파일의 최대 크기(Gb)                                          
    storageConfig:      ## 메타데이터를 저장할 위치 설정                                                
      registry:
        imageURL: example.com/mirror/oc-mirror-metadata                 
        skipTLS: false
    mirror:
      platform:
        channels:
        - name: stable-4.14                                             
          type: ocp
        graph: true          ## OSUS(OpenShift 업데이트 서비스)를 생성하기 위한 그래프 데이터 이미지를 생성할건지                                           
      operators:
      - catalog: registry.redhat.io/redhat/redhat-operator-index:v4.14  
        packages:
        - name: serverless-operator                                     
          channels:
          - name: stable                                                
      additionalImages:
      - name: registry.redhat.io/ubi9/ubi:latest                        
      helm: {}
    ```
    

# 4. image-set 생성

`oc mirror` 명령어를 사용해 image set 설정을 사용한 이미지 미러링 시작

```jsx
oc mirror --config=./imageset-config.yaml file://<path_to_output_directory>
```

- 결과물은 tar파일로 이를 disconnected 환경으로 옮겨 5번 과정 이어서 실행

# 5. 생성된 tar 파일을 miror registry로 미러링

```jsx
oc mirror --from=./mirror_seq1_000000.tar docker://registry.example:5000
```
Disconnected Mirroring.md
Disconnected Mirroring.md 표시 중입니다.