FROM node:7.2.0

RUN npm upgrade
RUN npm install -g elm@0.18.0
RUN npm install -g elm-test@0.18.0
ADD kompostedit kompostedit

#VOLUME ["/var/kompostedit"]
RUN cd kompostedit && npm install

EXPOSE 80 8000 3000

CMD ["npm", "start", "--prefix", "/kompostedit"]
