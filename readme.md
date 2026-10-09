# PoC de Infraestructura: Nginx con Docker

## 1. Descripción del proyecto

Despliegue de una landing page estática mediante Nginx dentro de un contenedor Docker, utilizando Docker Compose para gestionar el servicio.

El objetivo es servir contenido estático, configurar un Virtual Host y aplicar medidas básicas de hardening.

La página web desarrollada corresponde a **Guadalquivir Cloud Tech**, una empresa ficticia de servicios de infraestructura cloud, ciberseguridad, desarrollo web y soporte técnico.

## 2. Arquitectura

La infraestructura utiliza Docker para ejecutar Nginx de forma aislada y Docker Compose para definir la configuración del servicio.

```text
Navegador del usuario
        |
        | HTTP: localhost:8080
        v
Puerto 8080 del host (Windows)
        |
        | Mapeo de puertos 8080:80
        v
Contenedor Docker: poc-nginx
        |
        v
Nginx escuchando en el puerto 80
        |
        v
Archivos estáticos: HTML, CSS y vídeo
```

El puerto 8080 del equipo anfitrión se redirige al puerto 80 del contenedor, donde Nginx atiende las peticiones HTTP.

## 3. Estructura del proyecto

```text
PoC-Nginx/
├── conf/
│   └── default.conf
├── html/
│   ├── index.html
│   ├── css/
│   │   └── style.css
│   └── video/
│       └── hero.mp4
├── img/
│   ├── Captura1.png
│   ├── Captura2.png
│   └── Captura3.png
├── docker-compose.yml
└── README.md
```

- `html/`: contiene los archivos estáticos de la página web.
- `conf/default.conf`: contiene la configuración del servidor Nginx.
- `docker-compose.yml`: define el servicio, la imagen, los puertos y los volúmenes.
- `img/`: almacena las capturas de las comprobaciones realizadas.

## 4. Tecnologías utilizadas

- Docker y Docker Compose.
- Nginx `1.27-alpine`.
- HTML5 y CSS3.
- Windows 11 y PowerShell.

## 5. Configuración y medidas de hardening

La configuración del servidor se encuentra en `conf/default.conf`.

Se han aplicado las siguientes medidas:

- **Ocultación de la versión:** `server_tokens off` evita mostrar la versión de Nginx en las respuestas de error.
- **Protección frente a iframes:** `X-Frame-Options: SAMEORIGIN` restringe la inserción de la página en marcos de otros orígenes.
- **Protección MIME:** `X-Content-Type-Options: nosniff` evita que el navegador interprete los recursos como tipos distintos de los declarados.
- **Política de referencias:** `Referrer-Policy: strict-origin-when-cross-origin` limita la información de referencia enviada en solicitudes entre orígenes.
- **Política de seguridad de contenido:** `Content-Security-Policy` restringe los orígenes permitidos para determinados recursos.
- **Volúmenes de solo lectura:** los archivos web y la configuración se montan con `:ro`, evitando su modificación desde el contenedor a través de esos montajes.

Además, se utiliza la directiva `try_files` para servir los recursos existentes y devolver un error 404 cuando la ruta solicitada no se encuentra.

## 6. Despliegue y gestión del servicio

Para iniciar el servicio en segundo plano:

```bash
docker compose up -d
```

Para comprobar el estado del contenedor:

```bash
docker compose ps
```

Para consultar los registros de Nginx:

```bash
docker compose logs -f web
```

Para acceder a la shell del contenedor:

```bash
docker compose exec web sh
```

Para detener el servicio y eliminar el contenedor:

```bash
docker compose down
```

La aplicación está disponible en:

http://localhost:8080

## 7. Validación del despliegue

### 7.1. Comprobación de la respuesta HTTP

Se utiliza el siguiente comando para comprobar que el servidor responde correctamente y revisar las cabeceras HTTP:

```powershell
curl.exe -I http://localhost:8080
```

La respuesta obtenida fue `HTTP/1.1 200 OK`. También se verificó la presencia de las cabeceras de seguridad configuradas.

![Captura 1: comprobación de la respuesta HTTP](img/Captura1.png)

### 7.2. Comprobación desde el navegador

Se accedió a la aplicación desde el navegador y se utilizaron las herramientas de desarrollo, en la pestaña *Network*, para comprobar la carga de la página y de sus recursos estáticos.

Se verificó la respuesta de los recursos HTML, CSS y vídeo.

![Captura 2: validación de la página y sus recursos](img/Captura2.png)

### 7.3. Comprobación de los logs

Se consultaron los registros del servicio mediante:

```powershell
docker compose logs -f web
```

Al acceder y recargar la página desde el navegador, se observaron las peticiones recibidas por Nginx y sus correspondientes códigos de respuesta.

![Captura 3: registros de acceso de Nginx](img/Captura3.png)

## 8. Incidencia simulada

**Pendiente de realizar en la siguiente sesión.**

Se realizará el diagnóstico de una incidencia simulada que produzca una respuesta HTTP 403 o 404. Para ello, se revisarán los logs de Nginx, los archivos y permisos dentro del contenedor y la configuración del servidor.

Los resultados y la solución aplicada se documentarán una vez realizada la actividad.