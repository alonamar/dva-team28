import os


class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'jk3g5ljhg523lkjhg4'
