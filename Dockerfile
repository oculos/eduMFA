FROM python:3.10-slim-bookworm
COPY . .
RUN python -m pip install build --user && \
    python -m build --sdist --wheel --outdir dist/

FROM python:3.10-slim-bookworm

COPY --from=0 /dist/*.whl /dist/

RUN python -m pip install /dist/*.whl && pip install gunicorn && mkdir -p /opt/edumfa/user-scripts
COPY ./deploy/gunicorn/edumfaapp.py /opt/edumfa/app.py
COPY ./deploy/logging.cfg /etc/edumfa/logging.cfg
COPY ./deploy/docker-setup.sh /opt/edumfa/docker-setup.sh

EXPOSE 8000
WORKDIR /opt/edumfa

CMD ["./docker-setup.sh"]
