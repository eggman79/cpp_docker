FROM ubuntu:20.04
MAINTAINER eggman79@criptext.com

ARG project_name=project

RUN apt-get update -y
RUN apt-get install git neovim -y

ENV repo https://github.com/eggman79/

ENV neovim neovim_setup

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt install clang clang-tidy valgrind llvm llvm-dev -y

ENV CC clang
ENV CXX clang++

RUN git clone $repo/$neovim && cd $neovim && ./install.sh && nvim +PlugInstall +qall && cd .. && rm -rf $neovim
RUN apt-get install python software-properties-common -y
RUN add-apt-repository universe && apt update
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && python get-pip.py

RUN pip install conan
RUN pip install scipy

RUN git clone $repo/conan_gcc_patch && cd conan_gcc_patch && ./run.sh && cd .. && rm -rf conan_gcc_patch

RUN mkdir /root/$project_name

RUN git clone $repo/ycm_conan && cp ycm_conan/.ycm_extra_conf.py /root/$project_name

COPY . /root/$project_name

RUN cd /root/$project_name && sed -iE "s/\$project_name/$project_name/g" \
    CMakeLists.txt \
    src/CMakeLists.txt \
    bench/CMakeLists.txt \
    test/CMakeLists.txt \
    scripts/run_test_coverage.sh

RUN printf "\nexport CC=clang\nexport CXX=clang++\n" >> ~/.profile
RUN cd /root/$project_name/ && mkdir build && cd build && conan install .. -s compiler=clang -s compiler.version=10 -s compiler.libcxx=libstdc++ --build=missing && cmake ..

RUN cd /root/$project_name && ln -s `find ~/.conan/ -name compare.py | head -n1`

WORKDIR /root/$project_name
