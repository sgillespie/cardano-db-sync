"use strict";(self.webpackChunkdocusaurus=self.webpackChunkdocusaurus||[]).push([[564],{9737:(e,n,s)=>{s.r(n),s.d(n,{assets:()=>a,contentTitle:()=>c,default:()=>u,frontMatter:()=>r,metadata:()=>i,toc:()=>d});var t=s(4848),o=s(8453);const r={},c="Troubleshooting",i={id:"Guides/troubleshooting",title:"Troubleshooting",description:"Unable to connect to Unix domain socket /var/run/postgresql/.s.PGSQL.5432",source:"@site/docs/Guides/troubleshooting.md",sourceDirName:"Guides",slug:"/Guides/troubleshooting",permalink:"/cardano-db-sync/Guides/troubleshooting",draft:!1,unlisted:!1,editUrl:"https://github.com/sgillespie/cardano-db-sync/tree/docs/docusaurus/doc/docusaurus/docs/Guides/troubleshooting.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Schema Management",permalink:"/cardano-db-sync/Guides/schema-management"},next:{title:"Upgrading PostgreSQL",permalink:"/cardano-db-sync/Guides/upgrading-postgresql"}},a={},d=[{value:"Unable to connect to Unix domain socket /var/run/postgresql/.s.PGSQL.5432",id:"unable-to-connect-to-unix-domain-socket-varrunpostgresqlspgsql5432",level:2}];function l(e){const n={code:"code",h1:"h1",h2:"h2",p:"p",pre:"pre",...(0,o.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"troubleshooting",children:"Troubleshooting"}),"\n",(0,t.jsx)(n.h2,{id:"unable-to-connect-to-unix-domain-socket-varrunpostgresqlspgsql5432",children:"Unable to connect to Unix domain socket /var/run/postgresql/.s.PGSQL.5432"}),"\n",(0,t.jsx)(n.p,{children:"When running on MacOS, you get the following error:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-text",children:'      Exception: libpq: failed (could not connect to server: No such file or directory\n      \tIs the server running locally and accepting\n      \tconnections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?\n      )\n'})}),"\n",(0,t.jsxs)(n.p,{children:["This may indiciate that you do not have ",(0,t.jsx)(n.code,{children:"postgres"})," installed, or that the ",(0,t.jsx)(n.code,{children:"postgres"}),"\ndaemon is not running."]}),"\n",(0,t.jsxs)(n.p,{children:["You can install ",(0,t.jsx)(n.code,{children:"postgres"})," using Homebrew using:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"brew install postgres\n"})}),"\n",(0,t.jsxs)(n.p,{children:["And start the ",(0,t.jsx)(n.code,{children:"postgres"})," daemon using:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"brew services start postgresql\n"})}),"\n",(0,t.jsx)(n.p,{children:"And check that it is running using:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"brew services\nName       Status  User Plist\npostgresql started jky  /Users/jky/Library/LaunchAgents/homebrew.mxcl.postgresql.plist\n"})}),"\n",(0,t.jsxs)(n.p,{children:["If the daemon is running and the problem persists, then it could be because ",(0,t.jsx)(n.code,{children:"postgres"}),"\nis configured to create its unix domain socket on a path different to that expected by\n",(0,t.jsx)(n.code,{children:"cardano-db-sync"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"Assuming the daemon is running, the actual path to the unix domain socket can\nbe discovered by like this:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"$ lsof -p \"$(ps -ef | grep postgres | grep '[b]in/postgres' | xargs | cut -d ' ' -f 2)\" | grep 5432\npostgres 9050  jky    7u   unix 0xb7eadc9d471eb839      0t0                     /tmp/.s.PGSQL.5432\n"})}),"\n",(0,t.jsx)(n.p,{children:"We can work around the problem by sym-linking the expected path to the actual path:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-bash",children:"sudo ln -s /tmp/.s.PGSQL.5432 /var/run/postgresql/.s.PGSQL.5432\n"})})]})}function u(e={}){const{wrapper:n}={...(0,o.R)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(l,{...e})}):l(e)}},8453:(e,n,s)=>{s.d(n,{R:()=>c,x:()=>i});var t=s(6540);const o={},r=t.createContext(o);function c(e){const n=t.useContext(r);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function i(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(o):e.components||o:c(e.components),t.createElement(r.Provider,{value:n},e.children)}}}]);