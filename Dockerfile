FROM rocker/shiny

# La imagen base ya define LANG=en_US.UTF-8, pero no LC_ALL, y es LC_ALL el que
# manda. Sin un locale UTF-8, R no compara como iguales los literales acentuados
# de global.R con los valores que vienen del .xlsx, aunque los bytes sean
# idénticos: el mapa pierde el 52.5% de sus colores sin emitir un solo error.
# Ver informacion_adicional.md, §1.
#
# Va en_US.UTF-8 y NO C.UTF-8: los dos arreglan los colores, pero C.UTF-8 ordena
# por bytes y manda los acentos al final de su letra — "Cónico" quedaría después
# de "Cubano Amarillo" en cada selector construido con sort(). Son 14 razas.
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

COPY --chmod=755 ./scripts/install_reqs.sh /rocker_scripts/install_reqs.sh
RUN /rocker_scripts/install_reqs.sh

COPY . /srv/shiny-server/
