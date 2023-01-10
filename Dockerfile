ARG OUTPUT_DIR=/root/output
ARG EXECUTABLE_NAME=bootstrap

FROM ghcr.io/luvemil/base-hs-lambda:nightly-2022-11-12 as build

# Build the lambda
COPY . /root/lambda-function/

RUN cd /root/lambda-function
WORKDIR /root/lambda-function/

RUN stack clean --full
RUN stack build

ARG OUTPUT_DIR

RUN mkdir -p ${OUTPUT_DIR} && \
    mkdir -p ${OUTPUT_DIR}/lib

ARG EXECUTABLE_NAME

RUN cp $(stack path --local-install-root)/bin/${EXECUTABLE_NAME} ${OUTPUT_DIR}/${EXECUTABLE_NAME}

ENTRYPOINT sh

FROM public.ecr.aws/lambda/provided:al2 as deploy

ARG EXECUTABLE_NAME

WORKDIR ${LAMBDA_RUNTIME_DIR}

ARG OUTPUT_DIR

COPY --from=build ${OUTPUT_DIR} .

RUN mv ${EXECUTABLE_NAME} bootstrap || true

CMD [ "handler" ]
