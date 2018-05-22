pkg_name=national-parks
pkg_description="A sample JavaEE Web app deployed in the Tomcat8 package"
pkg_origin=dbhagen-github
pkg_version=7.3.0
pkg_maintainer="daniel.b.hagen@gmail.com"
pkg_license=('Apache-2.0')
pkg_deps=(core/tomcat8 core/jre8 core/mongo-tools)
pkg_build_deps=(core/jdk8/8u131 core/maven)
pkg_svc_user="root"
pkg_binds=(
  [database]="port"
)
#pkg_exports=(
#  [port]=tomcat_port
#)
#pkg_exposes=(port)

do_prepare()
{
    export JAVA_HOME=$(hab pkg path core/jdk8)
}

do_build()
{
    cp -r $PLAN_CONTEXT/../ $HAB_CACHE_SRC_PATH/$pkg_dirname
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}
    mvn package
}

do_install()
{
    mkdir -p "${PREFIX}/config"
    cp $(hab pkg path core/tomcat8)/config/conf_server.xml ${PREFIX}/config
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/target/${pkg_name}.war ${PREFIX}/
    cp -v ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/data/national-parks.json ${PREFIX}/
}
