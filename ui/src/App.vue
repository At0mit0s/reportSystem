<template>
  <v-app class="w-screen h-screen overflow-hidden" style="background: transparent; position: relative;">
    <v-main class="w-screen h-screen d-flex justify-center align-center bg-transparent">
      <v-card
        class="reportPanel bg-background_primary d-flex flex-column justify-start align-center py-5 px-10 rounded-lg elevation-24 animate__animated animate__fast"
        :class="[animationState ? 'animate__zoomIn' : 'animate__zoomOut', '']" transition="scale-transition"
        origin="center center" width="60%" height="524px" v-if="isActive" style="position: relative;">
        <div class="text-h6 font-weight-bold py-3 text-uppercase">{{ translateArray.title }}</div>
        <v-divider class="w-100"></v-divider>
        <Reports :reports="reports" :translate="translateArray.report" @deleteAllReports.once="deleteAllReports" @removeCurrentReport="removeCurrentReport" @solveCurrentReport="solveCurrentReport" @gotoToPlayer="gotoToPlayer" @bringPlayer="bringPlayer"/>
      </v-card>

    </v-main>
    <div id="toast"></div>
  </v-app>
</template>

<script>
import Reports from './components/Reports.vue'

export default {
  name: 'App',
  components: {
    Reports,
  },
  data() {
    return {
      isActive: false,
      animationState: false,
      newReport: false,
      reports: [],
      translateArray: [],
    }
  },
  mounted() {
    window.addEventListener('message', (event) => {
      if(event.data.translateArray != undefined) this.translateArray = event.data.translateArray;
      if (event.data.action == "reportActive") {
        this.isActive = true, this.animationState = true;
        if (JSON.parse(localStorage.getItem('reportArray')) != null){
          this.reports = JSON.parse(localStorage.getItem('reportArray'))
        }
        else{
          this.reports = []
        }
        // console.log(JSON.stringify(this.reports))
      }
      if (event.data.action == "reportDeactive") this.isActive = false;
      if (event.data.action == 'newReport') {
        if (JSON.parse(localStorage.getItem('reportArray')) != null) {
          this.reports = JSON.parse(localStorage.getItem('reportArray'))
          this.reports.push({
            title: event.data.newReport[0],
            message: event.data.newReport[1],
            name: event.data.newReport[2],
            id: event.data.newReport[3],
            date: event.data.newReport[4]
          })
          localStorage.setItem('reportArray', JSON.stringify(this.reports))
        }
        else {
          // console.log(JSON.stringify(event.data.newReport))
          this.reports.push(
            {
              title: event.data.newReport[0],
              message: event.data.newReport[1],
              name: event.data.newReport[2],
              id: event.data.newReport[3],
              date: event.data.newReport[4]
            }
          )
          // console.log(JSON.stringify(this.reports))
          localStorage.setItem('reportArray', JSON.stringify(this.reports))
        }
      }

      if(event.data.action == 'succesReport'){
        this.ToastSuccess()
      }

      if(event.data.action == 'gotoMessageToPlayer'){
        this.ToastPlayerGoto(event.data.gotoInfo[0], event.data.gotoInfo[1])
      }

      if(event.data.action == 'gotoMessageToMe'){
        this.ToastGoto(event.data.gotoInfo2[0], event.data.gotoInfo2[1])
      }

      if(event.data.action == 'bringMessageToPlayer'){
        this.ToastPlayerBring(event.data.bringInfo[0], event.data.bringInfo[1])
      }

      if(event.data.action == 'bringMessageToMe'){
        this.ToastBring(event.data.bringInfo2[0], event.data.bringInfo2[1])
      }

      if(event.data.action == 'reportRemoved'){
        this.removeReport(event.data.indexValue)
      }

      if(event.data.action == 'clearReports'){
        this.deleteAllReportsFromAllPlayer()
      }

      if(event.data.action == 'errorReport'){
        this.ToastError()
      }

      if(event.data.action == 'reportAllAdmin'){
        this.Toast(event.data.reportInfo[0], event.data.reportInfo[1])
      }

      if(event.data.action == 'reportSolved'){
        this.ToastSolved()
      }
    });

    // localStorage.clear()

    window.addEventListener("keydown", (event) => {
      if (event.key == 'Escape') {
        this.animationState = false;
        setTimeout(function () {
          fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
        }, 300)
      }
    });
  },
  methods: {
    deleteAllReports(){
      fetch(`https://${GetParentResourceName()}/deleteAllReports`).catch((error)=>console.log(''))
    },
    deleteAllReportsFromAllPlayer(){
      fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
      localStorage.clear()
      this.reports = []
    },
    removeCurrentReport(index){
      fetch(`https://${GetParentResourceName()}/removeCurrentReport`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(index),
      }).catch((error)=>console.log(''))
      fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
      this.ToastAdminRemoved()
    },
    removeReport(index){
      let reportsArrayCopy = this.reports
      reportsArrayCopy.splice(index, 1)
      this.reports = reportsArrayCopy
      localStorage.setItem('reportArray', JSON.stringify(this.reports))
    },
    solveCurrentReport(index, pId){
      fetch(`https://${GetParentResourceName()}/removeCurrentReport`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(index),
      }).catch((error)=>console.log(''))
      fetch(`https://${GetParentResourceName()}/reportSolved`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(pId),
      }).catch((error)=>console.log(''))
      fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
      this.ToastAdminSolved()
    },
    Toast(name, id){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.newReport} <span class='font-weight-bold font-italic text-primary'>${name} (${id})</span></p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastSuccess(){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-check"></i>
                  <p>${this.translateArray.alert.success}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastSolved(){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.solved}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastError(){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      toast.style.borderColor = "red"; 
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info" style='color: var(--error)'></i>
                  <p>${this.translateArray.alert.error}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastAdminRemoved(){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.toastAdminRemoved}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastAdminSolved(){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.toastAdminSolved}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastGoto(name, id){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.toastGoto} <span class='font-weight-bold font-italic text-primary'>${name} (${id})</span></p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastBring(name, id){
      // Create card div 
      var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p>${this.translateArray.alert.toastBring} <span class='font-weight-bold font-italic text-primary'>${name} (${id})</span></p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastPlayerGoto(name, id){
        // Create card div 
        var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p><span class='font-weight-bold font-italic text-primary'>${name} (${id})</span> ${this.translateArray.alert.toastGotoPlayer}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    ToastPlayerBring(name, id){
        // Create card div 
        var toast = document.createElement('div');
      // add class toast
      toast.classList.add('toast');
      
      toast.innerHTML = `
                  <i class="fa-solid fa-circle-info"></i>
                  <p><span class='font-weight-bold font-italic text-primary'>${name} (${id})</span> ${this.translateArray.alert.toastBringPlayer}</p>
      `;

      // get parentElement is #toast
      const toastList = document.querySelector('#toast');
      toastList.appendChild(toast);


      // hide Toast
      setTimeout(() => {
          // add animation hide for toast
          toast.style.animation = `hideToast ease 3s forwards`;
      },3000
      )

      // delete Toast in DOM 
      setTimeout(() => {
          toast.remove();
      },3000 + 3000)
    },
    gotoToPlayer(id){
      fetch(`https://${GetParentResourceName()}/gotoToPlayer`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(id),
      }).catch((error)=>console.log(''))
      // this.ToastGoto_Bring('goto to player!')
      fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
    },
    bringPlayer(id){
      fetch(`https://${GetParentResourceName()}/bringPlayer`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(id),
      }).catch((error)=>console.log(''))
      // this.ToastGoto_Bring('bringed player!')
      fetch(`https://${GetParentResourceName()}/closePanel`).catch((error)=>console.log(''))
    }
  }
}
</script>

<style>
:root {
  --primary: #0fd916;
  --error: red;
  --bg_primary_overlay: #606060;
}

/* width */
::-webkit-scrollbar {
  width: 3px;
}

/* Track */
::-webkit-scrollbar-track {
  background: transparent;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: var(--primary);
}
.notifyContent{
  position: absolute;
  top: 30px;
  right: 30px;
}
html{
  scroll-behavior: smooth;
}
/* Toast */
#toast {
  position : fixed;
  top : 15px;
  right : 10px;
  z-index: 10000;
  width: 340px;
}
.toast {
  position: relative;
  width: 100%;
  height: fit-content;
  display : flex;
  align-items : center;
  justify-content : start;
  margin: 15px 0;
  gap: 10px;
  padding : 20px 5px;
  font-size : 17px;
  border-left: 3px solid var(--primary);
  color : white;
  border-radius: 5px;
  overflow: hidden;
  animation : showToast ease 3s forwards;
}
.toast::after{
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #171717;
  z-index: -1;
  opacity: 0.8;
}
.toast > i{
    color: var(--primary);
    font-size: 20px;
    padding-left: 10px;
}
@keyframes showToast {
    0% {
        transform : translateX(100%);
    }

    25% {
        transform : translateX(-10%);
    }

    50% {
        transform : translateX(0%);
    }
    
    100% {
        transform : translateX(0%);
    }
}

@keyframes hideToast {
    0% {
        transform : translateX(0%);
    }

    25% {
        transform : translateX(-10%);
    }

    50% {
        transform : translateX(10px);
    }

    100% {
        transform : translateX(200%);
    }
}
</style>
