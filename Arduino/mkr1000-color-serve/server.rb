
require 'sinatra'
require 'socket'

set :bind, '0.0.0.0'

page = %[
<!doctype html>
<html>
<head>
  <style>
    .color {
      display: inline-block;
      width: 100px;
      height: 100px;
      margin: 16px;
    }
    .color.red {
      background: red;
    }

    .color.green {
      background: green;
    }

    .color.blue {
      background: blue;
    }

    .color.rand {
      border: 1px solid black;
    }
  </style>

  <script>

  function get(path) {
    var r = new XMLHttpRequest();
    r.open("GET", path, true);
    r.onreadystatechange = function () {
      if (r.readyState != 4 || r.status != 200) return;

      if (r.readyState === XMLHttpRequest.DONE && r.status === 200) {
        console.log("RESPONSE: ", r.responseText);
      }
    };
    r.send();
  }

  function r() {
    var c = Math.floor(Math.random() * 255).toString(16).toUpperCase();
    return c.length < 2 ? "0"+c : c;
  }

  function ready() {
    ['red', 'green', 'blue', 'rand'].forEach(function (el) {
      var b = document.querySelector('.' + el);
      b.addEventListener('click', function (evt) {
        evt.preventDefault();

        if (el == 'rand') {
          var c = r() + r() + r();
          b.style.background = "#" + c;
          get(c);
        } else {
          get(evt.target.href);
        }
        return false;
      })
    })
  }
  </script>
</head>
<body onload='ready()'>
<a class='color red' href='/FF0000'></a>
<a class='color green' href='/00FF00'></a>
<a class='color blue' href='/0000FF'></a>
<a class='color rand' href='/'></a>
</body>
</html>
]

get '/' do
  page
end

def socket_send_color(color)
  m   = color.match /(..)(..)(..)/
  # convert color string from hex to 3 unsigned character bytes
  out = [m[1].hex, m[2].hex, m[3].hex].pack('C*')

  # open socket, write color, close socket
  s = TCPSocket.new('192.168.1.115', 23)
  s.write out + "\n"
  s.close
end

get '/:color' do
  if /[A-F0-9]{6}/ =~ params[:color]
    socket_send_color params[:color]
    "COLOR ACCEPTED: #{ params[:color] }"
  else
    "NOPE"
  end
end
