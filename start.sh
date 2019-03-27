#!/bin/bash
source celeryAll.sh start
python3 manage.py runserver 0.0.0.0:8000