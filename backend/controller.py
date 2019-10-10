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

    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def index(self):
        return "Hello World {}".format(cherrypy.request)


    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def bins(self):
        bin1 = {'id': 'LE000051', 'weight': 394, 'ts': 1570733138}
        bin2 = {'id': 'LE000050', 'weight': 294, 'ts': 1570713138}
        bin3 = {'id': 'LE000041', 'weight': 119, 'ts': 1570613138}
        prod1 = {'name': 'Lechuga', 'bins': [bin1, bin2, bin3]}
        bin4 = {'id': 'RE000051', 'weight': 123, 'ts': 1570723138}
        bin5 = {'id': 'RE000050', 'weight': 321, 'ts': 1570703138}
        prod2 = {'name': 'Repollo', 'bins': [bin4, bin5]}
        return {'products': [prod1, prod2]}


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
