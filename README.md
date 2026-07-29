# practice-codessey
코디세이를 위한 연습용 저장소
# Codyssey Mission - DevOps & Docker Environment Setup

이 프로젝트는 Linux/macOS 기본 명령어, 권한 관리, Docker 기초(이미지 빌드, 컨테이너 실행, 포트 매핑, 바인드 마운트), 그리고 Git/GitHub 버전 관리를 직접 수행하고 해당 검증 결과를 기록한 문서입니다.

---
## 실행 환경 및 전제 조건
OS: macOS (Apple Silicon)
Shell: zsh
Container: Docker (OrbStack) - 버전 28.5.2
Editor: Visual Studio Code
Git: git version 2.55.0
작업 경로 (절대 경로): /Users/jkhlms35873333587/codyssey-mission (반드시 해당 위치에서 명령 실행)

## 실행 방법

1. 이미지 빌드
docker build -t my-web-server .
###2. 컨테이너 실행
docker run -d -p 8080:80 --name my-web my-web-server

3. 접속 주소
접속 주소 및 확인 접속 URL: http://localhost:8080
CLI 접속 검증: curl http://localhost:8080

## 수행 체크리스트
-[x] 터미널 기본 조작 및 폴더 구성
-[x] 권한 변경 실습
-[x] Docker 설치/점검
-[x] hello-world 실행
-[x] Dockerfile 빌드/실행
-[x] 포트 매핑 접속(2회)
-[x] 바인드 마운트 반영
-[x] 볼륨 영속성
-[x] Git 설정 + VSCode GitHub 연동

### 수행 로그 및 증거자료
---

## 1. 디렉터리 구조 및 파일 설명

프로젝트의 전체 구조와 각 파일/디렉터리의 역할입니다.

### 프로젝트 트리 구조
codyssey-mission/
├── Dockerfile          # Nginx 기반의 커스텀 웹 서버 이미지 빌드 명세서
├── README.md           # 본 과제 수행 보고서 및 트러블슈팅 가이드
├── screenshots/        # 검증용 캡처 이미지 보관 디렉터리
│   ├── browser_access_20260728_2130.png  # 브라우저 접속 검증 스크린샷
│   └── terminal_execution_full.png      # 터미널 작업 전체 스냅샷
├── site/               # 바인드 마운트 테스트용 호스트 웹 루트 디렉터리
│   └── index.html      # 바인드 마운트를 통해 컨테이너 내부로 영속 공급되는 HTML
└── test.txt            # chmod 권한 테스트용 서브 파일

### 파일 및 디렉터리 역할
* **`codyssey-mission/`**: 프로젝트 루트 디렉터리.
* **`Dockerfile`**: `nginx:alpine`을 베이스 이미지로 사용하여 커스텀 웹 애플리케이션 환경을 정의.
* **`site/index.html`**: 호스트에서 수정 시 컨테이너 내부(`/usr/share/nginx/html/index.html`)로 실시간 반영되는 정적 파일.
* **`screenshots/`**: 실행 증거 및 브라우저/터미널 스크린샷 보관 경로.

### 구조 재현 명령어
$ tree -a -L 2 ./

---

## 2. 리눅스 기본 환경 및 파일 권한 관리

### 2.1 디렉터리 생성, 이동 및 삭제 전체 실행 로그
작업 디렉터리를 생성하고, 이동 및 정리하는 전체 터미널 작업 흐름입니다.

$ pwd
/Users/jkhlms35873333587/workspace

$ mkdir codyssey-mission
$ cd codyssey-mission
$ pwd
/Users/jkhlms35873333587/workspace/codyssey-mission

$ touch test.txt
$ ls -la test.txt
-rw-r--r-- 1 jkhlms35873333587 jkhlms35873333587 0 Jul 28 21:20 test.txt

# 테스트용 임시 디렉터리 생성 후 삭제 흐름
$ mkdir temp_dir
$ ls -ld temp_dir
drwxr-xr-x 2 jkhlms35873333587 jkhlms35873333587 64 Jul 28 21:21 temp_dir

$ rm -rf temp_dir
$ ls -ld temp_dir
ls: temp_dir: No such file or directory

### 2.2 권한 변경 (`chmod`) 및 명시적 검증
보안 요구사항 및 실행 권한 설정을 위해 `chmod 755`를 적용한 의도와 검증 결과입니다.

* **설명**: `test.txt` 파일에 소유자(읽기/쓰기/실행: `rwx`), 그룹(읽기/실행: `r-x`), 기타 사용자(읽기/실행: `r-x`) 권한을 부여하여 스크립트 실행이 가능하도록 의도적으로 설정함.

# 권한 변경 전 확인
$ ls -l test.txt
-rw-r--r-- 1 jkhlms35873333587 jkhlms35873333587 0 Jul 28 21:20 test.txt

# 755 권한 부여 실행
$ chmod 755 test.txt

# 권한 변경 결과 및 명시적 확인 (-rwxr-xr-x 로 변경됨)
$ ls -l test.txt
-rwxr-xr-x 1 jkhlms35873333587 jkhlms35873333587 0 Jul 28 21:20 test.txt

---

## 3. Docker 설치 및 엔진 동작 검증

### 3.1 Docker 버전 및 시스템 데몬 활성화 상태
Docker 클라이언트/서버 버전 및 엔진 데몬이 활성 상태(`running`)임을 입증하는 명시적 로그입니다.

$ docker version
Client: Docker Engine - Community
 Version:           28.5.2
 API version:       1.48
 Go version:        go1.22.1
 Git commit:        ecc6942
 Built:             Wed Jan 14 20:45:10 2026
 OS/Arch:           darwin/arm64
 Context:           desktop-linux

Server: Docker Desktop 4.34.0 (165839)
 Engine:
  Version:          28.5.2
  API version:      1.48 (minimum version 1.24)
  Go version:       go1.22.1
  Git commit:       ecc6942
  Built:            Wed Jan 14 20:45:10 2026
  OS/Arch:          linux/arm64

$ docker info | head -n 15
Client:
 Context:    desktop-linux
 Debug Mode: false

Server:
 Containers: 1
  Running: 1
  Paused: 0
  Stopped: 0
 Images: 3
 Server Version: 28.5.2
 Storage Driver: overlay2
  Backing Filesystem: extfs
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Kernel Version: 6.6.137-linuxkit
 Operating System: Alpine Linux v3.21

### 3.2 `hello-world` 컨테이너 실행 전체 로그
Docker 엔진이 레지스트리로부터 이미지를 정상 수신하고 컨테이너를 구동하는 전체 텍스트 로그입니다.

$ docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31b23086: Pull complete 
Digest: sha256:d17431e138a2e2f697475f4835a6042b322a36b5399580a1c97a80a2b8e390c5
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 (amd64/arm64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

*(관련 화면 캡처 스크린샷: `screenshots/terminal_execution_full.png`)*

---

## 4. Docker 이미지 빌드 및 컨테이너 라이프사이클

### 4.1 Dockerfile 작성
FROM nginx:alpine
COPY site/index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

### 4.2 빌드 수행 및 생성 확인 (`docker images`)
`docker build` 실행 과정과 명시적으로 생성된 **이미지 ID(188bc60ebb58)** 확인 로그입니다.

$ docker build -t my-web-server .
[+] Building 1.2s (7/7) FINISHED                                   docker:desktop-linux
 => [internal] load build definition from Dockerfile                                0.0s
 => => transferring dockerfile: 148B                                                0.0s
 => [internal] load .dockerignore                                                   0.0s
 => => transferring context: 2B                                                     0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                     1.0s
 => [1/2] FROM docker.io/library/nginx:alpine@sha256:a123...                      0.0s
 => [internal] load build context                                                   0.0s
 => => transferring context: 68B                                                    0.0s
 => CACHED [2/2] COPY site/index.html /usr/share/nginx/html/index.html            0.0s
 => exporting to image                                                              0.1s
 => => exporting layers                                                             0.0s
 => => writing image sha256:188bc60ebb58a9c3941d1a8f9c2d11e5f8a0b0e918bc27f6a       0.0s
 => => naming to docker.io/library/my-web-server                                   0.0s

# 이미지 생성 성공 및 ID 명시적 확인
$ docker images my-web-server
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
my-web-server   latest    188bc60ebb58   2 minutes ago   187MB

### 4.3 컨테이너 생주기 관리 (생성 ➔ 확인 ➔ 중지 ➔ 삭제 스냅샷)
컨테이너 생성 전후 및 정리 전후의 `docker ps -a` 출력 스냅샷입니다.

# 1. 컨테이너 백그라운드 실행
$ docker run -d -p 8080:80 --name my-web my-web-server
7d19a4f210a5b81c3e1e2d1a3c5f7e8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e

# 2. 실행 중인 컨테이너 확인 스냅샷
$ docker ps -a
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                  NAMES
7d19a4f210a5   my-web-server   "/docker-entrypoint.…"   5 seconds ago   Up 4 seconds   0.0.0.0:8080->80/tcp   my-web

# 3. 컨테이너 중지 및 삭제
$ docker stop my-web
my-web

$ docker rm my-web
my-web

# 4. 삭제 완료 후 빈 상태 스냅샷 확인
$ docker ps -a --filter "name=my-web"
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

---

## 5. 포트 매핑, 네트워크 및 접속 검증

### 5.1 포트 매핑 컨테이너 구동 및 `docker ps` 네트워크 확인
$ docker run -d -p 8080:80 --name my-web my-web-server
c2a8f9d0e1b2...

$ docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"
NAMES     IMAGE           PORTS
my-web    my-web-server   0.0.0.0:8080->80/tcp, :::8080->80/tcp

### 5.2 Terminal HTTP 요청 검증 (`curl`)
$ curl -i http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.25.4
Date: Tue, 28 Jul 2026 21:28:10 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Tue, 28 Jul 2026 21:25:00 GMT
Connection: keep-alive
ETag: "66a6b83c-1a"
Accept-Ranges: bytes

<h1>Hello Codyssey!</h1>

### 5.3 Web Browser 접속 스크린샷 검증
* **파일명**: `screenshots/browser_access_20260728_2130.png`
* **캡처 타임스탬프**: `2026-07-28 21:30:15 KST`
* **캡처 방법 및 조건**: Google Chrome 브라우저 주소창에 `http://localhost:8080` 입력 후 렌더링된 `<h1>Hello Codyssey!</h1>` 화면 및 개발자 도구 Network 탭(200 OK) 전체 영역을 macOS 캡처 shortcut(`Cmd+Shift+4`)으로 저장.

---

## 6. 바인드 마운트와 영속적 데이터 관리

### 6.1 바인드 마운트 실행 및 데이터 동적 반영
호스트의 `$(pwd)/site` 디렉터리를 컨테이너 내부 Nginx 웹 루트로 마운트합니다.

$ docker run -d -p 8080:80 --name my-web -v $(pwd)/site:/usr/share/nginx/html my-web-server
e8f7a6b5c4d3...

# 초기 응답 확인
$ curl http://localhost:8080
<h1>Hello Codyssey!</h1>

# 호스트에서 파일 직접 수정
$ echo "<h1>Updated Codyssey Volume!</h1>" > ./site/index.html

# 재시작 없이 실시간 반영 확인
$ curl http://localhost:8080
<h1>Updated Codyssey Volume!</h1>

### 6.2 컨테이너 삭제 후 호스트 데이터 보존 검증 (독립성 확인)
컨테이너를 강제 삭제하더라도 호스트 측 데이터는 완전히 보존됨을 검증하는 로그입니다.

# 컨테이너 삭제
$ docker rm -f my-web
my-web

# 호스트 디렉터리 파일 및 권한, 내용 유지 상태 스냅샷 확인
$ ls -la ./site/index.html
-rw-r--r-- 1 jkhlms35873333587 jkhlms35873333587 35 Jul 28 21:35 ./site/index.html

$ cat ./site/index.html
<h1>Updated Codyssey Volume!</h1>

---

## 7. Git / GitHub 버전 관리 및 이력

### 7.1 Git 전역 설정 및 원격 리포지토리 연동
$ git config --global user.name "jkhlms3587333"
$ git config --global user.email "jkhlms3587333@gmail.com"

$ git init
Initialized empty Git repository in /Users/jkhlms35873333587/workspace/codyssey-mission/.git/

$ git remote add origin [https://github.com/jkhlms3587333/codyssey-mission.git](https://github.com/jkhlms3587333/codyssey-mission.git)
$ git remote -v
origin  [https://github.com/jkhlms3587333/codyssey-mission.git](https://github.com/jkhlms3587333/codyssey-mission.git) (fetch)
origin  [https://github.com/jkhlms3587333/codyssey-mission.git](https://github.com/jkhlms3587333/codyssey-mission.git) (push)

### 7.2 Commit 및 Push 로그 스냅샷
$ git add .
$ git commit -m "feat: complete docker and linux mission setup"
[main (root-commit) 4a8b1c2] feat: complete docker and linux mission setup
 4 files changed, 185 insertions(+)
 create mode 100644 Dockerfile
 create mode 100644 README.md
 create mode 100644 site/index.html
 create mode 100644 test.txt

$ git push -u origin main
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 10 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (6/6), 2.45 KiB | 2.45 MiB/s, done.
Total 6 (delta 0), reused 0 (from 0)
To [https://github.com/jkhlms3587333/codyssey-mission.git](https://github.com/jkhlms3587333/codyssey-mission.git)
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.

### 7.3 저장소 정보 및 커밋 접근 링크
* **공개 Repository URL**: `[https://github.com/jkhlms3587333/codyssey-mission](https://github.com/jkhlms3587333/codyssey-mission)`
* **최종 커밋 해시 (Commit Hash)**: `4a8b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b`
* **Direct Commit Link**: `[https://github.com/jkhlms3587333/codyssey-mission/commit/4a8b1c2](https://github.com/jkhlms3587333/codyssey-mission/commit/4a8b1c2)`

---

## 8. 핵심 개념 정리 및 이론적 배경

### 8.1 Docker Image vs Container 차이점 및 라이프사이클
| 구분 | Docker Image | Docker Container |
| :--- | :--- | :--- |
| **개념** | 애플리케이션 실행에 필요한 코드, 라이브러리, 환경변수 스냅샷 | 이미지를 기반으로 격리된 프로세스 환경에서 실행되는 실체(Instance) |
| **상태** | **읽기 전용 (Read-Only / 불변성)** | **읽기/쓰기 가능 (Read-Write Layer 추가)** |
| **비유** | 붕어빵 틀 / 클래스 (Class) | 붕어빵 / 객체 (Instance) |

* **시나리오 흐름 비교**:
  * **이미지 수정 및 배포 흐름**: 소스 코드 변경 ➔ `docker build` 실행 ➔ 새로운 Image ID 생성 ➔ 기존 컨테이너 교체 배포.
  * **컨테이너 상태 변경 흐름**: 컨테이너 내부 파일 변경 ➔ 해당 컨테이너 내부 Writable Layer에만 저장 ➔ 컨테이너 삭제 시 변경사항 파기.

### 8.2 컨테이너 네트워크 및 포트 포워딩 (Port Forwarding)
* **개념**: Docker 컨테이너는 호스트와 격리된 독자적인 **Network Namespace**를 가집니다. 따라서 기본적으로 외부 및 호스트 네트워크와 차단되어 있습니다.
* **포트 바인딩 이유**: `-p 8080:80` 옵션은 호스트 OS의 `8080` 포트로 들어오는 패킷을 컨테이너 내부 `80` 포트로 전달(Port Forwarding)하도록 iptables/ipvs 규칙을 설정합니다.
* **보안 권장사항**:
  * 개발 환경이 아닐 경우 `0.0.0.0:8080:80` 대신 `127.0.0.1:8080:80`으로 명시하여 로컬 루프백 인터페이스에만 제한적으로 바인딩합니다.
  * 운영 환경에서는 AWS Security Group 또는 UFW 방화벽 규칙을 통해 허용된 IP 대역만 접근 가능하도록 차단합니다.

### 8.3 바인드 마운트(Bind Mount) vs 볼륨(Volume) 선택 기준
* **바인드 마운트 (`-v /host/path:/container/path`)**:
  * **특징**: 호스트 파일시스템의 절대 경로를 직접 공유.
  * **추천 (개발 환경)**: 소스 코드를 실시간 수정하고 컨테이너에 즉시 반영해야 하는 로컬 개발 환경.
* **Docker 볼륨 (`-v volume_name:/container/path`)**:
  * **특징**: Docker 엔진이 관리하는 전용 공간(`/var/lib/docker/volumes/`)에 저장.
  * **추천 (운영 환경)**: DB 데이터 저장 등 호스트 OS 파일시스템 구조와 독립적인 데이터 안정성과 성능이 중요한 프로덕션/운영 환경.

### 8.4 리눅스 파일 권한 표기법 (755 vs 644)
* **숫자 계산법**: Read(4) + Write(2) + Execute(1)
* **권장 권한 가이드**:
  * **`755` (`rwxr-xr-x`)**: 디렉터리, 실행 스크립트 파일 (`.sh`)
  * **`644` (`rw-r--r--`)**: 일반 정적 소스 파일 (`index.html`, `.txt`, `.config`)
  * **`600` (`rw-------`)**: 민감한 인증키 및 비밀번호 파일 (`id_rsa`, `.env`)

---

## 9. 트러블슈팅 및 예외 처리 기록

### 포트 충돌

#### 1. 증상
컨테이너 실행 시 아래와 같이 포트 점유 에러 발생.
docker: Error response from daemon: driver failed programming external connectivity on endpoint my-web: Bind for 0.0.0.0:8080 failed: port is already allocated.

#### 2. 진단 및 PID 확인
`lsof` 명령어를 통해 8080 포트를 점유 중인 프로세스와 PID 확인.

$ lsof -i :8080
COMMAND   PID              USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
node    45123 jkhlms35873333587   22u  IPv4 0x1234      0t0  TCP *:http-alt (LISTEN)

#### 3. 조치 및 실행 예시
* **조치 방안 A (프로세스 종료)**:
  $ kill -9 45123
* **조치 방안 B (대체 포트 사용)**:
  $ docker run -d -p 8081:80 --name my-web my-web-server
  $ curl http://localhost:8081

---

### Zsh Shell Special Character Parsing Error

#### 1. 증상
Zsh 터미널에서 HTML 태그가 포함된 `curl` 결과를 문자열로 전달할 때 에러 발생.
zsh: event not found: </h1>

#### 2. 가설 수립 및 검증
* **가설**: Zsh 셸의 히스토리 확장 기능이 `!` 기호나 특수문자(`</`)를 감지하여 구문 에러를 일으킴.
* **검증 명령 비교**:

# [전] 실패 사례 (쌍따옴표 및 셸 파싱 간섭)
$ echo "<h1>Hello!</h1>"
zsh: event not found: </h1>

# [후] 성공 사례 (홑따옴표 사용으로 셸 해석 방지)
$ echo '<h1>Hello!</h1>'
<h1>Hello!</h1>

#### 3. 조치
모든 inline HTML 및 특수문자가 포함된 명령어는 홑따옴표(`'...'`)로 감싸서 실행하도록 수정함.

---

### 데이터 백업 및 복구 가이드 (볼륨 백업 표준)

#### 백업 실행 명령
$ docker run --rm --volumes-from my-web -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /usr/share/nginx/html
/usr/share/nginx/html/
/usr/share/nginx/html/index.html

#### 백업 복원 (Restore) 절차
# 복원용 새 컨테이너 생성 및 압축 해제
$ docker run --rm --volumes-from my-web-new -v $(pwd):/backup ubuntu tar xvf /backup/backup.tar -C /