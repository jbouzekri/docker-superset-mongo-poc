FROM apache/superset

USER root

RUN pip install pyathena

USER superset
