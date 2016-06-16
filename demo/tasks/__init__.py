import os
import random

from celery import Celery


class Config:
    CELERY_TIMEZONE = 'Europe/Paris'
    CELERY_ENABLE_UTC = True
    CELERY_ACCEPT_CONTENT = ['json']
    CELERY_TASK_SERIALIZER = 'json'
    CELERY_RESULT_SERIALIZER = 'json'


cel = Celery(
    'demo',
    broker=os.getenv('CELERY_BROKER'),
    backend=os.getenv('CELERY_RESULT_BACKEND')
)
cel.config_from_object(Config)


@cel.task
def super_dupper_task():
    return random.randint(0, 100)
