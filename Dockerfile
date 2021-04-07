# Docker Officialのrustイメージを使います
FROM rust:1.43 AS builder

# /todoでビルドを行うことにします
WORKDIR /todo

# ビルドに必要なファイルをイメージにコピーします
COPY Cargo.toml Cargo.toml

RUN mkdir src
RUN echo "fn main(){}" > src/main.rs

RUN cargo build --release

COPY ./src ./src
COPY ./templates ./templates

RUN rm -f target/release/deps/todo*

# ビルドします
RUN cargo build --release

FROM debian:10.4
COPY --from=builder /todo/target/release/todo /usr/bin/todo
# コンテナ起動時にwebアプリを実行します
CMD ["todo"]
