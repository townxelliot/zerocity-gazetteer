SRC_DIR=../src

margin=30mm

source ~/venv/troikadocs/bin/activate

python3 jinjabook.py > $SRC_DIR/gazetteer.html

version=`cat $SRC_DIR/meta.json | jq '.version'| sed -e 's|"||g'`
date=`cat $SRC_DIR/meta.json | jq '.date' | sed -e 's|["-]||g'`
OUT_FILE="$SRC_DIR/pdfs/zerocity_v${version}-${date}.pdf"

echo "Writing PDF to $OUT_FILE"

/home/ell/apps/wkhtmltox/bin/wkhtmltopdf -s A4 --footer-spacing 15 --footer-center "[page]" -B $margin -L $margin -R $margin -T $margin toc $SRC_DIR/gazetteer.html $OUT_FILE
