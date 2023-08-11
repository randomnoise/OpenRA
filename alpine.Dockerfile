FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine3.18

ENV PYTHONUNBUFFERED=1

# install dependencies
RUN apk add --update --no-cache \
alsa-lib \
freetype \
lua5.1 \
make \
mesa-dri-gallium \
mesa-gl \
openal-soft \
python3 \
sdl2 \
zenity

RUN ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# restore NuGet packages
WORKDIR /nuget-packages
COPY . /nuget-packages
RUN make clean \
 && dotnet restore \
 && rm -rf /nuget-packages/

WORKDIR /openra

CMD ["sh", "-c", "make TARGETPLATFORM=unix-generic; ./launch-game.sh Game.Mod=ra"]
