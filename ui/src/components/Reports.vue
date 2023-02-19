<template>
    <div class="w-100 h-100 my-3 px-3 d-flex flex-column justify-start align-center overflow-auto"
        style="position: relative;">

        <div class="reportMessage text-h7 font-weight-bold font-italic">
            {{ translate.noReport }}
        </div>

        <v-expansion-panels class="panelGroup">

            <v-expansion-panel v-for="report, index in filteredReports"
                class="bg-background_secondary my-2 animate__animated animate__zoomIn expansionButtons" :title="capitalize(report.title)"
                :style="{ 'animation-delay': index * 0.15 + 's' }" @click="scrollToPanel(index)">
                <v-expansion-panel-text class="bg-background_secondary" style="border-top: 2px solid var(--primary);">
                    <div class="information w-100 d-flex flex-row justify-space-between align-center mb-5">
                        <div class="name" style="opacity: 0.6;">
                            {{ translate.reportBadgeTitle }}
                            <v-chip class="ma-2" color="primary" text-color="white" prepend-icon="mdi-account-circle">
                                {{ report.name }} ({{ report.id }})
                            </v-chip>
                        </div>
                        <div class="date text-primary font-weight-medium">{{ report.date }}</div>
                    </div>
                    <div class="message" :id="index">{{ report.message }}</div>
                    <div class="actions_content w-10 d-flex justify-center align-center mt-5" style="gap: 10px; position: relative;">
                        <v-btn color="primary" @click="gotoToPlayer(report.id)">
                            Goto
                        </v-btn>

                        <v-btn color="primary" @click="bringPlayer(report.id)">
                            Bring
                        </v-btn>

                        <v-btn color="error" @click="removeReport(index)">
                            {{ translate.removeButton }}
                        </v-btn>

                        <v-btn @click="solveReport(index, report.id)" icon color="primary d-flex justify-center align-center" style="width: 35px; height: 35px; transform: translateY(-50%); position: absolute; top: 50%; right: 0px;"><i class="fa-solid fa-check font-weight-bold" style="font-size: 18px; color: white;"></i></v-btn>
                    </div>
                </v-expansion-panel-text>
            </v-expansion-panel>

        </v-expansion-panels>
    </div>

    <div class="search_section w-50 d-flex flex-row justify-center align-center" style="transform: scale(0.8); gap: 10px;">
        <div class="iconHolder pb-5 w-30 d-flex flex-row justify-center align-center"><i
                class="fa-solid fa-magnifying-glass"
                style="font-size: 30px; text-shadow: 0px 0px 5px rgba(255, 255, 255, 0.3);"></i></div>
        <v-text-field clearable :label="translate.searchPlaceholder" v-model="search"></v-text-field>
        <v-btn icon color="primary" class="mb-5" @click="deleteLocalstorage()">
            <i class="fa-solid fa-trash text-white"></i>
        </v-btn>
    </div>
</template>
  
<script>
export default {
    name: 'Reports',
    props: {
        reports: Object,
        translate: Object,
    },
    data(){
        return {
            search: '',
        }
    },
    mounted(){
        if(this.reports.length != 0){
            document.querySelector('.panelGroup').style.display = 'block'
            document.querySelector('.reportMessage').style.display = 'none'
        }
        else{
            document.querySelector('.panelGroup').style.display = 'none'
            document.querySelector('.reportMessage').style.display = 'block'
        }
    },
    computed: {
      filteredReports() {
        if (!this.search || this.search.length <= 0) return this.reports;
        
        return this.reports.filter((report) =>
          isNaN(parseInt(this.search)) ? report.name.toLowerCase().includes(this.search.toLowerCase()) : parseInt(this.search) == report.id
        );
      },
    },
    methods: {
        deleteLocalstorage() {
            this.$emit('deleteAllReports')
        },
        capitalize(str) {
            return str.charAt(0).toUpperCase() + str.slice(1)
        },
        removeReport(index) {
            this.$emit('removeCurrentReport', index)
        },
        solveReport(index, pId){
            this.$emit('solveCurrentReport', index, pId)
        },
        scrollToPanel(id){
            setTimeout(function(){
                if(document.getElementById(`${id}`) != null){
                    document.getElementById(`${id}`).scrollIntoView({behavior: 'smooth', block: 'center'});
                }
            },240)
        },
        gotoToPlayer(id){
            this.$emit('gotoToPlayer', id)
        },
        bringPlayer(id){
            this.$emit('bringPlayer', id)
        }
    },
    emits: ['deleteAllReports','removeCurrentReport', 'solveCurrentReport', 'gotoToPlayer', 'bringPlayer']
}
</script>

<style>
.v-expansion-panel-title__overlay {
    background-color: var(--bg_primary_overlay) !important;
}

.v-field__overlay {
    background-color: var(--bg_primary_overlay) !important;
}

.reportMessage {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
</style>