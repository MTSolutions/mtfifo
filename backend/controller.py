# -*- coding: utf-8 -*-
import cherrypy
from cherrypy.lib import static
import cherrypy_cors
from datetime import datetime as dt
from datetime import timedelta as td
import os

def CORS():
    cherrypy.response.headers["Access-Control-Allow-Origin"] = "*"
    cherrypy.response.headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
    cherrypy.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    cherrypy.response.headers['Content-Type'] = 'application/json'

class Root(object):

    fifo = [
        {'id': 'LE000051', 'weight': 394, 'ts': int((dt.now() - (dt.now() - td(seconds=5000))).total_seconds())},
        {'id': 'LE000050', 'weight': 294, 'ts': int((dt.now() - (dt.now() - td(seconds=5500))).total_seconds())},
        {'id': 'LE000041', 'weight': 119, 'ts': int((dt.now() - (dt.now() - td(seconds=20000))).total_seconds())},
        {'id': 'RE000051', 'weight': 123, 'ts': int((dt.now() - (dt.now() - td(seconds=35000))).total_seconds())},
        {'id': 'RE000050', 'weight': 321, 'ts': int((dt.now() - (dt.now() - td(seconds=265400))).total_seconds())}
    ]

    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def index(self):
        return "Hello World {}".format(cherrypy.request)


    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def bins(self):
        return {'products': sorted(self.fifo, key=lambda x: x['ts'], reverse=True)}

    
    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def markbin(self, _id):
        message = 'Bin {} incorrecto'.format(_id)
        for item in self.fifo:
            if item['id'] == _id:
                self.fifo.remove(item)
                message = 'Bin {} procesado correctamente'.format(_id)
                
        return {'status': 'ok', 'message': message}


if __name__ == '__main__':
    cherrypy_cors.install()
    cherrypy.tools.CORS = cherrypy.Tool('before_handler', CORS)
    cherrypy.config.update({
        'server.socket_host': '0.0.0.0',
        'server.socket_port': 8080,
    })

    cherrypy.quickstart(Root(), '', {'/': {
        'tools.CORS.on': True
    }})
