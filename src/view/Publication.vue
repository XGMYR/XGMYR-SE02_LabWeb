<template>
  <div class="container">
    <div class="title">Daily Record</div>
    <!-- <div style="width: 100%">
          <el-input
            v-model="input2"
            class="pinput"
            placeholder="Type something"
          >
            <template #suffix>
              <img
                class="searchbtn"
                src="\src\assets\picture\search.png"
                alt=""
              />
            </template>
          </el-input>
        </div> -->
    <el-tabs v-model="activeName" class="tabs">
      <el-tab-pane label="Public" name="public">
        <div class="pub-list" v-infinite-scroll="load" v-if="ready">
          <div v-for="(item, index) in tableData" :key="index" class="tablediv">
            <img style="width: 30%; object-fit: cover" :src="item.Thumbnail" />
            <div class="card-words">
              <div>
                <div style="color: rgba(0, 0, 0, 0.54)">
                  {{ item.date }}
                </div>
                <div
                  style="font-size: 25px; margin-top: 10px; font-weight: bold"
                >
                  {{ item.Title }}
                </div>
                <div>
                  {{ item.Authors }}
                </div>
                <div style="margin-top: 5px">
                  {{ item.Abstract }}
                </div>
              </div>
              <div class="words-bottom">
                <span>[<el-link :href="item.Link">LINK/PDF</el-link>]</span>
              </div>
            </div>
          </div>
        </div>
        <el-empty
          description="No Any Publication"
          v-if="tableData.length == 0"
        />
      </el-tab-pane>
      <el-tab-pane label="Private" name="private" v-if="store.state.token" lazy>
        <div class="pub-list" v-infinite-scroll="loadPrivate" v-if="ready">
          <div
            v-for="(item, index) in tableDataPrivate"
            :key="index"
            class="tablediv"
          >
            <img style="width: 30%; object-fit: cover" :src="item.Thumbnail" />
            <div class="card-words">
              <div>
                <div style="color: rgba(0, 0, 0, 0.54)">
                  {{ item.date }}
                </div>
                <div
                  style="font-size: 25px; margin-top: 10px; font-weight: bold"
                >
                  {{ item.Title }}
                </div>
                <div>
                  {{ item.Authors }}
                </div>
                <div style="margin-top: 5px">
                  {{ item.Abstract }}
                </div>
              </div>
              <div class="words-bottom">
                <span>[<el-link :href="item.Link">LINK/PDF</el-link>]</span>
              </div>
            </div>
          </div>
        </div>
        <el-empty
          description="No Any Publication"
          v-if="tableDataPrivate.length == 0"
      /></el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { useStore } from "vuex";
import { getCurrentInstance, onMounted, reactive, ref } from "vue";
import { Publications } from "../api/api";
import config from "../api/config";

const store = useStore();
const ready = ref(false);

const tableData = reactive([]);
const tableDataPrivate = reactive([]);
const activeName = ref("public");

const page = ref(1);
const pagePrivate = ref(1);
const load = () => {
  page.value++;
  getData(page.value);
};
const loadPrivate = () => {
  pagePrivate.value++;
  getPrivateData(pagePrivate.value);
};
onMounted(() => {
  getData();
  getPrivateData();
  ready.value = true;
});
const getData = async (page = 1) => {
  let data = await Publications.getPublicPublications(page, config.pageLimit);
  if (data)
    data.forEach((item) => {
      tableData.push(item);
    });
};
const getPrivateData = async (page = 1) => {
  if (store.state.token) {
    let data = await Publications.getPrivatePublications(
      page,
      config.pageLimit,
      (err) => {
        if (err.response.status === 401) {
          ElMessage.error("???????????????");
          store.commit("clearToken");
          router.push("/login");
        } else ElMessage.error("????????????");
      }
    );
    if (data)
      data.forEach((item) => {
        tableDataPrivate.push(item);
      });
  }
};
</script>

<style scoped>
.container {
  padding: 0 400px 50px 400px;
}
.container .title {
  padding: 30px 0 20px 0;
  color: hsl(203, 66%, 60%);
  font-size: 35px;
  font-weight: bold;
}
.tablediv {
  display: flex;
  margin-top: 25px;
  background-color: white;
  box-shadow: 0 1px 4px rgb(0 0 0 / 8%);
  border-radius: 3px;
  border: 1px solid rgba(0, 0, 0, 0.09);
  padding: 10px 15px 10px 15px;
}
.pub-list {
  margin-left: auto;
  margin-right: auto;
  width: 100%;
}
.card-words {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  margin: 10px 0 0 30px;
}
.words-bottom span {
  margin-right: 10px;
}
:deep(.el-tabs__item.is-active) {
  color: hsl(203, 66%, 60%);
}
:deep(.el-tabs__item:hover) {
  color: hsl(203, 66%, 60%);
}
:deep(.el-tabs__active-bar) {
  background-color: hsl(203, 66%, 60%);
}
</style>
