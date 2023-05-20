FROM sphinxdoc/sphinx:latest as builder
WORKDIR /netmaker-docs
COPY . /netmaker-docs/
RUN pip install sphinx_material

RUN ["make","html"]
RUN ["/bin/ls"]

FROM nginx:1.19
COPY --from=builder /netmaker-docs/_build/html /usr/share/nginx/html
RUN sed -i '/rel=\"next\"\ title=\"About\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/\"\ />' /usr/share/nginx/html/index.html
