# Source: https://github.com/pwntester/ysoserial.net/issues/9#issuecomment-790819759
mkdir /opt/tools/ysoserialnet/
dpkg --add-architecture i386
apt update
apt install -y mono-complete wine winetricks wine32:i386
wget https://github.com/pwntester/ysoserial.net/releases/download/v1.36/ysoserial-1dba9c4416ba6e79b6b262b758fa75e2ee9008e9.zip -O /opt/tools/ysoserialnet/ysoserialnet.zip
unzip -o /opt/tools/ysoserialnet/ysoserialnet.zip -d /opt/tools/ysoserialnet/
mv /opt/tools/ysoserialnet/Release/* /opt/tools/ysoserialnet/
rm -rf /opt/tools/ysoserialnet/Release/
rm /opt/tools/ysoserialnet/ysoserialnet.zip
winetricks -q dotnet48