"use strict";(self.webpackChunkdocusaurus=self.webpackChunkdocusaurus||[]).push([[370],{9651:(e,s,n)=>{n.r(s),n.d(s,{assets:()=>a,contentTitle:()=>o,default:()=>u,frontMatter:()=>i,metadata:()=>l,toc:()=>d});var r=n(4848),t=n(8453);const i={},o="Upgrading PostgreSQL",l={id:"Guides/upgrading-postgresql",title:"Upgrading PostgreSQL",description:"For major releases of PostgreSQL, the internal storage format is typically changed,",source:"@site/docs/Guides/upgrading-postgresql.md",sourceDirName:"Guides",slug:"/Guides/upgrading-postgresql",permalink:"/cardano-db-sync/Guides/upgrading-postgresql",draft:!1,unlisted:!1,editUrl:"https://github.com/sgillespie/cardano-db-sync/tree/docs/docusaurus/doc/docusaurus/docs/Guides/upgrading-postgresql.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Troubleshooting",permalink:"/cardano-db-sync/Guides/troubleshooting"},next:{title:"Validation",permalink:"/cardano-db-sync/Guides/validation"}},a={},d=[{value:"Requirements",id:"requirements",level:2},{value:"Install a New PostgreSQL Version",id:"install-a-new-postgresql-version",level:2},{value:"Upgrade the Schemas",id:"upgrade-the-schemas",level:2},{value:"Clean Up",id:"clean-up",level:2}];function c(e){const s={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",ul:"ul",...(0,t.R)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(s.h1,{id:"upgrading-postgresql",children:"Upgrading PostgreSQL"}),"\n",(0,r.jsx)(s.p,{children:"For major releases of PostgreSQL, the internal storage format is typically changed,\ncomplicating upgrades."}),"\n",(0,r.jsx)(s.h2,{id:"requirements",children:"Requirements"}),"\n",(0,r.jsxs)(s.ul,{children:["\n",(0,r.jsx)(s.li,{children:"350GiB free space"}),"\n"]}),"\n",(0,r.jsx)(s.p,{children:"This guide uses examples for Debian, but should apply to any Linux distribution."}),"\n",(0,r.jsx)(s.h2,{id:"install-a-new-postgresql-version",children:"Install a New PostgreSQL Version"}),"\n",(0,r.jsxs)(s.p,{children:["If you're using Debian (or Ubuntu), make sure you've enabled the ",(0,r.jsx)(s.a,{href:"https://wiki.postgresql.org/wiki/Apt",children:"PostgreSQL APT\nrepository"}),", which will enable you to install\nmultiple versions."]}),"\n",(0,r.jsx)(s.p,{children:"Install a new PostgreSQL version alongside the existing:"}),"\n",(0,r.jsx)(s.pre,{children:(0,r.jsx)(s.code,{className:"language-bash",children:"sudo apt install postgresql-15\n"})}),"\n",(0,r.jsx)(s.h2,{id:"upgrade-the-schemas",children:"Upgrade the Schemas"}),"\n",(0,r.jsx)(s.p,{children:"Stop Cardano DB Sync PostgreSQL"}),"\n",(0,r.jsx)(s.pre,{children:(0,r.jsx)(s.code,{className:"language-bash",children:"sudo systemctl stop postgresql\nsudo pkill -f cardano-db-sync\n"})}),"\n",(0,r.jsx)(s.p,{children:"Upgrade the existing schemas"}),"\n",(0,r.jsx)(s.pre,{children:(0,r.jsx)(s.code,{className:"language-bash",children:'cd /tmp\nsudo -u postgres /usr/lib/postgresql/15/bin/pg_upgrade \\\n  --old-bindir=/usr/lib/postgresql/11/bin \\\n  --new-bindir=/usr/lib/postgresql/15/bin \\\n  --old-datadir=/var/lib/postgresql/11/main \\\n  --new-datadir=/var/lib/postgresql/15/main \\\n  --old-options="--config_file=/etc/postgresql/11/main/postgresql.conf" \\\n  --new-options="--config_file=/etc/postgresql/14/main/postgresql.conf"\n'})}),"\n",(0,r.jsx)(s.p,{children:"Start PostgreSQL"}),"\n",(0,r.jsx)(s.pre,{children:(0,r.jsx)(s.code,{className:"language-bash",children:"sudo systemctl start postgresql\n"})}),"\n",(0,r.jsx)(s.h2,{id:"clean-up",children:"Clean Up"}),"\n",(0,r.jsx)(s.p,{children:"Remove the old PostgreSQL version"}),"\n",(0,r.jsx)(s.pre,{children:(0,r.jsx)(s.code,{className:"language-bash",children:"sudo -u postgres ./delete-old-cluster.sh\nsudo apt remove postgresql\n"})})]})}function u(e={}){const{wrapper:s}={...(0,t.R)(),...e.components};return s?(0,r.jsx)(s,{...e,children:(0,r.jsx)(c,{...e})}):c(e)}},8453:(e,s,n)=>{n.d(s,{R:()=>o,x:()=>l});var r=n(6540);const t={},i=r.createContext(t);function o(e){const s=r.useContext(i);return r.useMemo((function(){return"function"==typeof e?e(s):{...s,...e}}),[s,e])}function l(e){let s;return s=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:o(e.components),r.createElement(i.Provider,{value:s},e.children)}}}]);