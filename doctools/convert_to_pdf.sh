SRC_DIR=../src

horizontal_margin=15mm
top_margin=15mm
bottom_margin=25mm

source ~/venv/troikadocs/bin/activate

python3 jinjabook.py ../src/introduction.md > $SRC_DIR/intro.html
python3 jinjabook.py ../src/book.md > $SRC_DIR/book.html

version=`cat $SRC_DIR/meta.json | jq '.version'| sed -e 's|"||g'`
date=`cat $SRC_DIR/meta.json | jq '.date' | sed -e 's|["-]||g'`
OUT_FILE="$SRC_DIR/pdfs/zerocity_v${version}-${date}.pdf"

echo "Writing PDF to $OUT_FILE"

/home/ell/apps/wkhtmltox/bin/wkhtmltopdf -s A4 --footer-spacing 15 --footer-center "[page]" -B $bottom_margin -L $horizontal_margin -R $horizontal_margin -T $top_margin $SRC_DIR/intro.html toc --xsl-style-sheet ./templates/toc-stylesheet.xsl $SRC_DIR/book.html $OUT_FILE
