#!/bin/bash
iris qlist prd | grep 'Disaster Recovery^Connected' ; if [ $? -eq 0 ] ; then echo "I am a DR" ; else echo "I am NOT a DR" ;fi
