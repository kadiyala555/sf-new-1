//class testing pull request and find difference test getdiff check the diff.
public with sharing class AddNumbers {
    public AddNumbers() {
        System.debug('Inside constructor');
    }

    public Integer addandres(Integer firstnum, Integer secondnum){
        return firstnum+secondnum;
    }
}