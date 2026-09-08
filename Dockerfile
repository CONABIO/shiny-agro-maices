FROM rocker/shiny

# Sin un locale UTF-8, R no compara como iguales los literales acentuados de global.R
# con los valores que vienen del .xlsx, aunque los bytes sean idénticos: el mapa pierde
# el 52.5% de sus colores sin emitir un solo error. Ver informacion_adicional.md, §1.
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY --chmod=755 ./scripts/install_reqs.sh /rocker_scripts/install_reqs.sh
RUN /rocker_scripts/install_reqs.sh

COPY . /srv/shiny-server/
