# dingdong
A minimal but nerdy setup to ring a doorbell: a webhook that plays an audio file.

This Docker image is based on the latest version of Ubuntu and comes pre-installed with **webhook**, **sox**, and **libsox-fmt-all**. The working directory is set to `/etc/webhook` and the webhook **port 9000** is exposed. When the container is started, it will run the webhook server with the specified hooks file `hooks.json` in verbose mode.

The image is used to run a container that hosts a webhook. When pulled, the webhook runs a script that plays an MP3 file. The use case for this image is to play a doorbell sound when the doorbell in a house is rang.

## Example
As an example, a physical doorbell is mounted at the entrance of a house. The doorbell is wired to a Loxone Home Automation system, which is connected to node-red. Whenever the doorbell switch is pressed, Loxone triggers a flow in node-red. This flow then pulls the webhook and plays the MP3 file.

## Setup
The container that runs the image mounts the `/dev/snd` device, as well as a volume `dingdong_data` which is mounted to `/etc/webhook` in the container.

The volume contains two files: `hooks.json` and `play_audio.sh`.

### hooks.json
The `hooks.json` file contains the configuration for the webhook server. It specifies the ID of the webhook (`dingdong`) and the command to execute when the webhook is pulled (`/etc/webhook/play_audio.sh`). The working directory for the command is also specified (`/etc/webhook/`).

Here’s an example `hooks.json` file:
``` json
[
  {
    "id": "dingdong",
    "execute-command": "/etc/webhook/play_audio.sh",
    "command-working-directory": "/etc/webhook/"
  }
]
```
### play_audio.sh
The `play_audio.sh` script contains the command to play the MP3 file using `sox`. In this example, it plays an MP3 file located at `/etc/webhook/chime.mp3` with a volume of 5.0.

Here’s an example `play_audio.sh` script:
``` bash
#!/bin/bash

play -v 5.0 /etc/webhook/chime.mp3
```
**Note:** Make sure to set the executable bit using `chmod +x ./play_audio.sh`.

## Running the Container
To run a container with this image, use the following command:

``` console
docker run -p 9000:9000 --device /dev/snd -v dingdong_data:/etc/webhook knutalee/dingdong:latest
```
This will start a container and map port 9000 of the host to port 9000 of the container, allowing you to access the webhook server from outside the container. It also mounts the `/dev/snd` device and the `dingdong_data` volume.

You can also use Docker Compose to run the container. Here’s an example `docker-compose.yml` file:
``` yaml
version: '3'
services:
  doorbell:
    image: knutaleee/dingdong:latest
    ports:
      - "9000:9000"
    devices:
      - /dev/snd
    volumes:
      - dingdong_data:/etc/webhook
```
To start the container using Docker Compose, run docker-compose up.

# License
This project is licensed under GNU GPL license.
