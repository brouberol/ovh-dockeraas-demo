from flask import Flask, jsonify

from .tasks import cel, super_dupper_task

app = Flask(__name__)


@app.route('/')
def index():
    return 'Hello world!\n'


@app.route('/mon/ping')
def ping():
    return 'pong\n'


@app.route('/tasks', methods=['POST'])
def submit_task():
    async_res = super_dupper_task.delay()
    return jsonify({'task_id': async_res.id}), 202


@app.route('/tasks/<task_id>')
def get_task_result(task_id):
    data = cel.backend.get_task_meta(task_id)
    return jsonify(data), 200
