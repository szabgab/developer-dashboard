FROM perl:5.32
RUN cpanm Mojolicious Path::Tiny YAML
RUN cpanm Mojolicious::Plugin::AutoReload
RUN cpanm IO::Socket::SSL
WORKDIR /opt
#COPY app.pl .
#COPY data data
#CMD ["perl", "app.pl", "daemon"]
CMD ["morbo", "app.pl"]
