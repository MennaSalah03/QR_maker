import streamlit as st
import segno
import io
from PIL import Image
import qrcode_artistic

# --- Page Configuration ---
st.set_page_config(page_title="Custom QR Code Generator", page_icon="🎨")

st.title("🎨 Custom QR Code Generator")
st.markdown("Create beautiful QR codes with custom colors and background images.")

# --- Sidebar: Configuration ---
st.sidebar.header("Settings")

# 1. Data Input
url_input = st.sidebar.text_input("Enter URL or Text", value="")

# 2. Artistic Options
st.sidebar.subheader("Artistic Style")
uploaded_file = st.sidebar.file_uploader("Upload Background Image (Optional)", type=["png", "jpg", "jpeg", "gif"])

# 3. Color Customization
dark_color = st.sidebar.color_picker("QR Body Color", "#000000") # Default DarkBlue

# Logic for Light Color (Background)
use_transparent_bg = st.sidebar.checkbox("Transparent Background", value=False)

if use_transparent_bg:
    light_color = None  # Segno interprets None as transparent
    bg_preview = "Transparent"
else:
    light_color = st.sidebar.color_picker("Background Color (Light Modules)", "#FFFFFF")
    bg_preview = light_color

# 4. Sizing
scale_val = st.sidebar.slider("Scale (Size)", min_value=1, max_value=20, value=5)
border_val = st.sidebar.slider("Quiet Zone (Border)", min_value=0, max_value=10, value=1)

# 5. Format
# If an image is uploaded, we restrict to PNG to ensure blending works easily
if uploaded_file:
    file_format = "png"
    st.sidebar.info("Format locked to PNG for artistic backgrounds.")
else:
    file_format = st.sidebar.selectbox("Output Format", ["png", "svg", "pdf"])


# --- Main Area: Generation ---

if st.button("Generate QR Code", type="primary"):
    if not url_input:
        st.warning("Please enter a URL or text first!")
    else:
        try:
            # 1. Create Basic QR Object
            # We use error='h' (High) to allow for artistic damage/logos
            qr = segno.make_qr(url_input, error='h')
            
            # 2. Prepare Memory Buffer
            buffer = io.BytesIO()

            # 3. Generate Based on Mode
            if uploaded_file:
                # --- ARTISTIC MODE (With Background Image) ---
                # We must rewind the uploaded file to ensure it reads from the start
                uploaded_file.seek(0)
                
                qr.to_artistic(
                    background=uploaded_file,
                    target=buffer,
                    kind='png', # Artistic usually works best with raster formats
                    dark=dark_color,
                    light=light_color,
                    scale=scale_val,
                    border=border_val
                )
            else:
                # --- STANDARD MODE (Colors Only) ---
                qr.save(
                    buffer,
                    kind=file_format,
                    dark=dark_color,
                    light=light_color,
                    scale=scale_val,
                    border=border_val
                )

            # 4. Display and Download
            buffer.seek(0)
            
            st.subheader("Result")
            
            # Displaying depends on format. Streamlit displays PNG/JPG easily.
            # SVGs/PDFs are harder to preview directly, so we show a success message or render SVG.
            if file_format == "png":
                st.image(buffer, caption="Your Custom QR Code")
            else:
                st.success(f"QR Code generated successfully as {file_format.upper()}!")

            # Reset buffer pointer again for the download button
            buffer.seek(0)
            
            st.download_button(
                label=f"Download {file_format.upper()}",
                data=buffer,
                file_name=f"custom_qr.{file_format}",
                mime=f"image/{file_format}" if file_format != 'svg' else "image/svg+xml"
            )

        except Exception as e:
            st.error(f"An error occurred: {e}")