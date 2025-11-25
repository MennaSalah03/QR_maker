import segno
import io
from PIL import Image

# Take inputs from user (iamge path and URL)
input_image = "Images/linkedin.png"
input_url = "https://www.linkedin.com/in/menna-salah-535561237/"
img_extension = 'png'
BG="#FFFFFF"
img_buffer = io. BytesIO()


qrcode = segno.make_qr(input_url, error = 'h')




qrcode.to_artistic(background = input_image
                   , target = img_buffer
                   , kind = img_extension
                   , dark = "darkblue"
                   , scale = 5
                   , light = BG
                   )

img_buffer.seek(0)
