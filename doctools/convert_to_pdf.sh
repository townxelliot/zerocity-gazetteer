GAZETTEER_DIR=../zerocity_gazetteer

margin=30mm

source ~/venv/troikadocs/bin/activate

python3 jinjabook.py > $GAZETTEER_DIR/gazetteer.html

version=`cat $GAZETTEER_DIR/meta.json | jq '.version'| sed -e 's|"||g'`
date=`cat $GAZETTEER_DIR/meta.json | jq '.date' | sed -e 's|["-]||g'`
OUT_FILE="$GAZETTEER_DIR/pdfs/zerocity_v${version}-${date}.pdf"

echo "Writing PDF to $OUT_FILE"

/home/ell/apps/wkhtmltox/bin/wkhtmltopdf --footer-spacing 15 --footer-center "[page]" -s A4 -B $margin -L $margin -R $margin -T $margin ../zerocity_gazetteer/gazetteer.html $OUT_FILE
