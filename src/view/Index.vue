<template>
  <div>
    <!-- banner -->
    <div
      class="banner"
      :style="route.name != 'Home' ? { background: '#4A708B' } : {}"
    >
      <div class="container">
        <div class="header">
          <div class="w3_agile_logo">
            <div class="bantitle">
              Lab of TEAM
              <br />软工团队研究室
            </div>
          </div>
          <div class="clearfix"></div>
        </div>
        <div class="ban-top">
          <div class="top_nav_left">
            <div class="navbar-collapse menu--shylock collapse">
              <ul class="menu__list">
                <li
                  style="margin: 0 30px 0 0"
                  :class="menu.class"
                  v-for="(menu, index) in menus"
                  :key="index"
                >
                  <a class="menu__link" @click="to(menu.url)">{{
                    menu.name
                  }}</a>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div class="flexslider">
          <!-- <div class="banimg"></div> -->
          <img src="../assets/img/team.jpg" />
        </div>
      </div>
    </div>
    <div class="main">
      <router-view></router-view>
    </div>
    <div class="footer">
      <div class="container">
        <div class="col-md-4 agileinfo_footer_gridl">
          <h3>加入我们</h3>
          <p>Phone number:{{ contact.value.phone }}</p>
          <p>address:{{ contact.value.address }}</p>
          <p>Postcode: {{ contact.value.postcode }}</p>
          <p>Email:{{ contact.value.email }}</p>
        </div>
        <div class="col-md-4 agileinfo_footer_gridl">
          <h3>期望</h3>
          <p>{{ contact.value.hope }}</p>
        </div>
        <div class="col-md-4 agileinfo_footer_gridr">
          <h3>一些主要人员/负责人</h3>
          {{ contact.value.people }}
        </div>
      </div>
      <div class="cpr">
        © 2022 Lab of team, Fuzhou University.
      </div>
    </div>
  </div>
</template>
<script setup>
import { computed, reactive, onBeforeMount, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useStore } from "vuex";
import { Config } from "../api/api";
const store = useStore();
const route = useRoute();
const router = useRouter();
const menus = computed(() => {
  let currentTab = route.name;
  let token = store.state.token;
  let defalut = [
    {
      name: "Home",
      url: "/",
    },
    {
      name: "Daily Record",
      url: "/publications",
    },
    {
      name: "Resource",
      url: "/resource",
    },
    {
      name: "Schedule",
      url: "/schedule",
    },
  ];
  if (token)
    defalut.push({
      name: "Upload",
      url: "/upload",
      hide: true,
    });
  else
    defalut.push({
      name: "Login",
      url: "/login",
    });
  defalut.forEach((item) => {
    if (item.name == currentTab)
      item.class = "menu__item active menu__item--current";
    else item.class = "menu__item";
  });
  return defalut;
});
const to = (url) => {
  router.push(url);
};
const contact = reactive({
  value: {
    phone: "",
    address: "",
    postcode: "",
    email: "",
    hope: "",
    people: "",
  },
});
onBeforeMount(() => {
  store.commit("initToken");
});
onMounted(() => {
  getConfig();
});
const getConfig = () => {
  Config.getConfig("contact").then((resp) => {
    contact.value = JSON.parse(resp.data.Value);
  });
};
</script>
<style scoped>
@import url("../assets/css/Home.css");
.banner {
  max-height: v-bind("route.name!='Home'?'210px':'724px'");
  overflow: hidden;
  background: url(../assets/img/fzuback.jpg) no-repeat;
  background-size: cover;
  position: relative;
  transition: max-height 0.5s ease;
}

.flexslider {
  margin: 40px 0 30px 0;
}
.flexslider img {
  width: calc(45vw);
  max-width: 800px;
  max-height: 450px;
}
.bantitle {
  font-size: 35px;
  /* 渐变文字颜色的关键*/
  -webkit-text-stroke: 1px black 0.8;
  color: white;
  cursor: default;
}
.main {
  min-height: calc(100vh - 225px);
}
.cpr {
  margin-top: 20px;
  width: 100%;
  text-align: center;
  color: white;
}
</style>
