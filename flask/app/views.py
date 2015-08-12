from flask import render_template, flash, redirect, session, url_for, request
from datetime import datetime
from app import app
from flaskext.markdown import Markdown
Markdown(app)


@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'), 404


@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return render_template('500.html'), 500


@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
    return render_template('index.html',
                           title='Home' )

@app.route('/env/', methods=['GET'])
def env():
    return render_template('env.html')


@app.route('/sp1/', methods=['GET'])
def sp1():
    return render_template('sp1.html')

@app.route('/sb2/', methods=['GET'])
def sb2():
    return render_template('sb2.html')

@app.route('/ck1/', methods=['GET'])
def ck1():
    return render_template('ck1.html')

@app.route('/cl1/', methods=['GET'])
def cl1():
    return render_template('cl1.html')

@app.route('/dp1/', methods=['GET'])
def dp1():
    return render_template('dp1.html')

@app.route('/ans/', methods=['GET'])
def dp1():
    return render_template('ans.html')

@app.route('/docs/', methods=['GET'])
def docs():
    return render_template('docs.html', **locals())

@app.route('/docs/install_jenkins', methods=['GET'])
def install_jenkins():
    return render_template('docs/install_jenkins.html', **locals())

@app.route('/docs/create_ubuntu', methods=['GET'])
def create_ubuntu():
    return render_template('docs/create_ubuntu.html', **locals())

@app.route('/docs/setup_ssh', methods=['GET'])
def setup_ssh():
    return render_template('docs/setup_ssh.html', **locals())

@app.route('/docs/install_vca_cli', methods=['GET'])
def installing_vca_cli():
    return render_template('docs/install_vca_cli.html', **locals())

@app.route('/lab/mac', methods=['GET'])
def lab_mac():
    return render_template('lab/mac.html', **locals())

