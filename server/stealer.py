import http.server
import socketserver

PORT = 8000

f = open('collected', 'a+')

class GetHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):

        self.send_response(200)
        if self.path == '/kill':
            f.close()
            httpd.server_close()
        f.write(self.path+'\n')




Handler = http.server.BaseHTTPRequestHandler

with socketserver.TCPServer(("", PORT), GetHandler) as httpd:
    print("serving at port", PORT)

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()