import json
import os
import sys

from markdown import markdown
from jinja2 import Environment, FileSystemLoader, Markup


class Templater:

    # book_markdown_path: relative to content_directory
    # master_template: Jinja2 template name
    # meta_json_path: file containing additional variables to inject into context
    # content_directory: location of content files, as referenced by markdown filter
    def __init__(self, book_markdown_path, master_template, meta_json_path, content_directory='.'):
        here = os.path.dirname(__file__)

        self.content_directory = content_directory

        file_loader = FileSystemLoader(os.path.join(here, 'templates'))
        self.env = Environment(loader=file_loader)
        self.env.filters['markdown'] = lambda value: self.markdown_filter(value)

        self.template = self.env.get_template(master_template)

        with open(os.path.join(content_directory, meta_json_path), 'r') as meta_file:
            self.meta = {'meta': json.loads(meta_file.read())}

        # add the book markdown path, which is injected into the master template
        self.meta['book'] = book_markdown_path

    def markdown_filter(self, path):
        # path is relative to self.content_directory
        full_path = os.path.abspath(os.path.join(self.content_directory, path))
        with open(full_path, 'r') as markdown_file:
            processed = self.env.from_string(markdown_file.read()).render(**self.meta)
            return markdown(processed)

    def render(self):
        return self.template.render(**self.meta)


if __name__ == '__main__':
    markdown_file = sys.argv[1]

    content_dir = os.path.join(os.path.dirname(__file__), '..', 'src')
    t = Templater(markdown_file, 'master.jinja', 'meta.json', content_dir)
    html = t.render()

    print(html)
