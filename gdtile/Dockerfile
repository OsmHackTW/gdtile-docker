FROM osmtw/tilestache:1.31.0
MAINTAINER Rex Tsai <rex.cc.tsai@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y wget unzip unifont

WORKDIR /usr/local/src
# install sharp files
RUN wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip \
 && wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
RUN unzip simplified-land-polygons-complete-3857.zip -d ../osm-data/ \
 && unzip land-polygons-split-3857.zip -d ../osm-data/ \
 && rm -fv simplified-land-polygons-complete-3857.zip land-polygons-split-3857.zip

RUN git clone --depth 1 https://github.com/OsmHackTW/gdtile.git
RUN sed -e s%../bin/cascadenik-compile.py%cascadenik-compile.py% -e s%\\.\\./%/usr/% -e "s%/usr/bin/uwsgi --ini%/usr/bin/uwsgi --plugin python --ini%" gdtile/run-server.py -i \
 && sed -e 's%srs="\&EPSG3857a;"%%g' \
    -e 's%<Map%<Map srs="\&EPSG3857a;"%' \
    -e 's%<Layer%<Layer srs="\&EPSG3857a;"%' gdtile/layers.mml  -i

# Clean up APT when done
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entry.sh /usr/local/bin/entry.sh
RUN chmod 755 /usr/local/bin/entry.sh
CMD ["/usr/local/bin/entry.sh"]
