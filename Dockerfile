FROM alpine:3.12.0
  WORKDIR /haskellweekly
  RUN apk update && apk add cabal ghc musl-dev wget zlib-dev
  COPY haskellweekly.cabal .
  RUN cabal update && cabal build --only-dependencies
  COPY . .
  RUN cabal install --installdir /usr/local/bin --install-method copy
FROM alpine:3.12.0
  RUN apk update && apk add gmp libffi
  ENV haskellweekly_datadir=/usr/local/share/haskellweekly
  COPY --from=0 /haskellweekly/data/ /usr/local/share/haskellweekly/
  COPY --from=0 /usr/local/bin/haskellweekly /usr/local/bin
  CMD haskellweekly
